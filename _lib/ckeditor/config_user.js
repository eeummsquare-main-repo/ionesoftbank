/*
Copyright (c) 2003-2011, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
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
	//config.uiColor='#000000'

	config.toolbar = [
		 ['Bold','Italic','Underline','Strike','-','RemoveFormat'],
		 ['Font','FontSize'],
		 ['TextColor','BGColor'],
		 ['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
		 ['Link','Unlink','Image','Flash'],
		 ['About'],
		 '/'
	];

};