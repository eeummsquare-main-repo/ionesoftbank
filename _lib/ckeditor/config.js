/**
 * @license Copyright (c) 2003-2015, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.md or http://ckeditor.com/license
 */

CKEDITOR.editorConfig = function( config ) {
	// Define changes to default configuration here. For example:

	config.docType = '<!DOCTYPE html>';
	config.language = 'ko';
	config.height=300;
	/* BR MODE IE 11 한글입력시 줄바꿈 오류 있음.
	config.enterMode=CKEDITOR.ENTER_BR;
	config.shiftEnterMode=CKEDITOR.ENTER_BR;
	*/

	config.enterMode=CKEDITOR.ENTER_P;
	config.shiftEnterMode=CKEDITOR.ENTER_P;
	CKEDITOR.config.allowedContent = true;
	//CKEDITOR.config.fillEmptyBlocks = false;
	CKEDITOR.config.baseFloatZIndex = "999999";
	CKEDITOR.config.pasteFilter = null;
	//config.uiColor='#000000'

	config.toolbar = [
		 ['Source','NewPage','Maximize'],
		 ['Cut','Copy','Paste','PasteText','PasteFromWord'],
		 ['Undo','Redo','-','Find','Replace'],
		 ['Link','Unlink','Anchor'],
		 ['Image','Flash','Table','HorizontalRule','Smiley'],
		 '/',
		 ['Bold','Italic','Underline','Strike','-','Subscript','Superscript','-','RemoveFormat'],
		 ['Font','FontSize'],
		 ['TextColor','BGColor'],
		 ['NumberedList','BulletedList'],
		 ['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
		 ['About'],
		 '/'
	];

	//config.font_names="NanumSquare;NanumSquare L;NanumSquare B;NanumSquare EB;"+CKEDITOR.config.font_names;
	config.filebrowserBrowseUrl = '/_lib/ckeditor/fileupload.asp';
	config.filebrowserImageBrowseUrl = '/_lib/ckeditor/fileupload.asp?type=Images';
	config.filebrowserFlashBrowseUrl = '/_lib/ckeditor/fileupload.asp?type=Flash';
	//config.filebrowserUploadUrl = '/ckeditor/ckfinder/core/connector/asp/connector.asp?command=QuickUpload&type=Files';
	//config.filebrowserImageUploadUrl = '/ckeditor/ckfinder/core/connector/asp/connector.asp?command=QuickUpload&type=Images';
	//config.filebrowserFlashUploadUrl = '/ckeditor/ckfinder/core/connector/asp/connector.asp?command=QuickUpload&type=Flash';
	config.filebrowserWindowWidth = '800';
 	config.filebrowserWindowHeight = '700';

};

/*
['Source','-','Save','NewPage','Preview','-','Templates'],
['Cut','Copy','Paste','PasteText','PasteFromWord','-','Print', 'SpellChecker', 'Scayt'],
['Undo','Redo','-','Find','Replace','-','SelectAll','RemoveFormat'],
['Form', 'Checkbox', 'Radio', 'TextField', 'Textarea', 'Select', 'Button', 'ImageButton', 'HiddenField'],
'/',
['Bold','Italic','Underline','Strike','-','Subscript','Superscript'],
['NumberedList','BulletedList','-','Outdent','Indent','Blockquote'],
['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
['Link','Unlink','Anchor'],
['Image','Flash','Table','HorizontalRule','Smiley','SpecialChar','PageBreak'],
'/',
['Styles','Format','Font','FontSize'],
['TextColor','BGColor'],
['Maximize', 'ShowBlocks','-','About']
*/