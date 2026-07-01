$('head').append('<link rel="stylesheet" type="text/css" href="/_lib/ckeditor5/content.css">');

$(document).ready(function() {
	$(".ckeditor5").each( function(index){
		var get_id = $(this).attr("id");
		if( !get_id ) return true;

		ClassicEditor.create( document.querySelector( '#'+get_id ), {
			extraPlugins: [MyCustomUploadAdapterPlugin],
			//toolbar: ['heading' ,'|', "fontColor","fontBackgroundColor",'bold','italic',"underline" ,'|', "alignment" ,'|', "bulletedList","numberedList","|","codeBlock","outdent","indent","|",'link',"imageInsert","blockQuote","insertTable","mediaEmbed" ,'|', "undo","redo"],
			toolbar: ['heading' ,'|', 'fontSize', 'bold','italic',"underline","fontColor","fontBackgroundColor" ,'|', "alignment" ,'|', "bulletedList","numberedList","|","codeBlock","outdent","indent","|",'link',"blockQuote","imageInsert","insertTable","mediaEmbed", "SourceEditing"],
			image: { toolbar: ["imageTextAlternative", "imageStyle:inline", "imageStyle:block", "imageStyle:side", "linkImage", "toggleImageCaption"] },
			mediaEmbed: {
				previewsInData: true
			},htmlSupport: {
			  allow: [
				{
//				  name: /.*/
//				  ,attributes: true
//				  ,classes: true
//				  styles: true
				}
			  ]
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

function setCKEDITOR5(get_id){
	ClassicEditor.create( document.querySelector( '#'+get_id ), {
		extraPlugins: [MyCustomUploadAdapterPlugin],
		//toolbar: ['heading' ,'|', "fontColor","fontBackgroundColor",'bold','italic',"underline" ,'|', "alignment" ,'|', "bulletedList","numberedList","|","codeBlock","outdent","indent","|",'link',"imageInsert","blockQuote","insertTable","mediaEmbed" ,'|', "undo","redo"],
		toolbar: ['heading' ,'|', 'fontSize', 'bold','italic',"underline","fontColor","fontBackgroundColor" ,'|', "alignment" ,'|', "bulletedList","numberedList","|","codeBlock","outdent","indent","|",'link',"blockQuote","imageInsert","insertTable","mediaEmbed", "SourceEditing"],
		image: { toolbar: ["imageTextAlternative", "imageStyle:inline", "imageStyle:block", "imageStyle:side", "linkImage", "toggleImageCaption"] },
		mediaEmbed: {
			previewsInData: true
		}
			,htmlSupport: {
			  allow: [
				{
//				  name: /.*/
//				  ,attributes: true
//				  ,classes: true
				  styles: true
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
}

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