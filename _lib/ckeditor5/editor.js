$('head').append('<link rel="stylesheet" type="text/css" href="/_lib/ckeditor5/content.css">');

$(document).ready(function() {
	$(".ckeditor5").each( function(index){
		var get_id = $(this).attr("id");
		if( !get_id ) return true;

		ClassicEditor.create( document.querySelector( '#'+get_id ), {
			heading : {
				options: [
					{ model: 'paragraph',  title: 'Paragraph', class: 'ck-heading_paragraph' },
					{ model: 'heading1', view: 'h2', title: 'Heading 1', class: 'ck-heading_heading1' },
					{ model: 'heading2', view: 'h3', title: 'Heading 2', class: 'ck-heading_heading2' },
					{ model: 'heading3', view: 'h4', title: 'Heading 3', class: 'ck-heading_heading3' },
				]
			},
			extraPlugins: [MyCustomUploadAdapterPlugin],
			//toolbar: ['heading' ,'|', "fontColor","fontBackgroundColor",'bold','italic',"underline" ,'|', "alignment" ,'|', "bulletedList","numberedList","|","codeBlock","outdent","indent","|",'link',"imageInsert","blockQuote","insertTable","mediaEmbed" ,'|', "undo","redo"],
			toolbar: ['heading' ,'|', 'bold','italic',"underline","fontColor","fontBackgroundColor" ,'|', "alignment" ,'|', "bulletedList","numberedList","|","codeBlock","outdent","indent","|",'link',"blockQuote","imageInsert","insertTable","mediaEmbed"],
			image: { toolbar: ["imageTextAlternative", "imageStyle:inline", "imageStyle:block", "imageStyle:side", "linkImage", "toggleImageCaption"] },
			mediaEmbed: {
				previewsInData: true
			},link: {
            decorators: {
                addTargetToExternalLinks: {
                    mode: 'automatic',
                    callback: url => /^(https?:)?\/\//.test( url ),
                    attributes: {
                        target: '_blank'
                    }
                }
            }
        }, 
			htmlSupport: {
			  allow: [
				{
				  name: /.*/
				  ,attributes: true
				  ,classes: true
//				  ,styles: true
				}
			  ]
			}
		} )
		.then( editor => {
			window.editor = editor;
		} )
		.catch( err => {
			console.error( err.stack );
		} );
	});
});

class UploadAdapter {
    constructor(loader) {
        this.loader = loader;
    }

    upload() {
        return this.loader.file.then( file => new Promise(((resolve, reject) => {
            this._initRequest();
            this._initListeners( resolve, reject, file );
            this._sendRequest( file, ed_nonce);
        })))
    }

    _initRequest(){
        const xhr = this.xhr = new XMLHttpRequest();
        xhr.open('POST', '/_lib/ckeditor5/fileupload.asp', true);
        xhr.responseType = 'json';
    }

    _initListeners(resolve, reject, file) {
        const xhr = this.xhr;
        const loader = this.loader;
		const genericErrorText = "Couldn't upload file";

        xhr.addEventListener('error', () => {reject(genericErrorText)})
        xhr.addEventListener('abort', () => reject())
        xhr.addEventListener('load', () => {
            const response = xhr.response
            if(!response || response.error) {
                return reject( response && response.error ? response.error.message : genericErrorText );
            }

            resolve({
                default: response.url //업로드된 파일 주소
            })
        })
    }

    _sendRequest(file, ed_nonce) {
        const data = new FormData()
        data.append('upload',file)
        data.append('ed_nonce',ed_nonce)

        this.xhr.send(data)
    }
}

function MyCustomUploadAdapterPlugin(editor) {
    editor.plugins.get('FileRepository').createUploadAdapter = (loader) => {
        return new UploadAdapter(loader)
    }
}

// 2026-06-11 추가: 게시판 글 저장 시 본문 <img> 태그에 alt가 비어있으면 자동으로 채워 SEO/접근성 누락 방지.
//  - 파일명이 의미 있는 텍스트면 그것을 alt로, 의미 없는 숫자/타임스탬프면 "첨부 이미지"로.
//  - 편집자가 직접 alt를 입력한 경우는 그대로 보존.
$(document).ready(function () {
    $("form").on("submit", function () {
        if (!window.editor || typeof window.editor.getData !== "function") return;
        var html = window.editor.getData();
        var changed = false;
        var newHtml = html.replace(/<img\b([^>]*)>/gi, function (match, attrs) {
            var altMatch = attrs.match(/\balt\s*=\s*["']([^"']*)["']/i);
            if (altMatch && altMatch[1].trim() !== "") return match;
            var srcMatch = attrs.match(/\bsrc\s*=\s*["']([^"']+)["']/i);
            var altText = "첨부 이미지";
            if (srcMatch) {
                var filename = srcMatch[1].split("/").pop().split("?")[0];
                var base = filename.replace(/\.[a-z0-9]+$/i, "");
                try { base = decodeURIComponent(base); } catch (e) {}
                if (!/^[\d_%\-\s]+$/.test(base)) {
                    altText = base.replace(/[%_\-]+/g, " ").trim() || "첨부 이미지";
                }
            }
            changed = true;
            if (altMatch) {
                return match.replace(/\balt\s*=\s*["'][^"']*["']/i, 'alt="' + altText + '"');
            }
            return "<img alt=\"" + altText + "\"" + attrs + ">";
        });
        if (changed) {
            window.editor.setData(newHtml);
        }
    });
});