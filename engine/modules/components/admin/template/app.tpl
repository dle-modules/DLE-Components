<!DOCTYPE html>
<html lang="ru">
	<head>
		<meta charset="{$config.dle.charset}">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">    

		<title>{$config.module.moduleName}</title>

		{Action::run('getCss')}
	    {* ! https://github.com/bdadam/OptimizedWebfontLoading *} 
		<script>
			{ignore} 
			function loadFont(t,e,n,o){function a(){if(!window.FontFace)return!1;var t=new FontFace("t",'url("data:application/font-woff2,") format("woff2")',{}),e=t.load();try{e.then(null,function(){})}catch(n){}return"loading"===t.status}var r=navigator.userAgent,s=!window.addEventListener||r.match(/(Android (2|3|4.0|4.1|4.2|4.3))|(Opera (Mini|Mobi))/)&&!r.match(/Chrome/);if(!s){var i={};try{i=localStorage||{}}catch(c){}var d="x-font-"+t,l=d+"url",u=d+"css",f=i[l],h=i[u],p=document.createElement("style");if(p.rel="stylesheet",document.head.appendChild(p),!h||f!==e&&f!==n){var w=n&&a()?n:e,m=new XMLHttpRequest;m.open("GET",w),m.onload=function(){m.status>=200&&m.status<400&&(i[l]=w,i[u]=m.responseText,o||(p.textContent=m.responseText))},m.send()}else p.textContent=h}} 
			{/ignore}
		loadFont('OpenSans', '{$theme}/assets/fonts/opensans.css', '{$theme}/assets/fonts/opensans-woff2.css');</script>

		<link href="{$theme}/assets/css/main.css" rel="stylesheet">
	</head>
	<body>
		<div class="body-wrapper clearfix">
			<div class="container container-main">
				<div class="content">
					<div class="col col-mb-hide col-hide col-dt-3">
						<div class="sidebar">
							{include 'sidebar.tpl'}
						</div>
					</div> <!-- .col col-mb-hide col-hide col-dt-3 -->
					<div class="col col-mb-12 col-dt-9 col-padding-bottom">
						<div class="breadcrumb"><span class="item">{$config.module.moduleDecription} (v.{$config.module.version})</span></div>
						{if $.session.message!}
							{include '/actions/alert.tpl' message=$.session.message type=$.session.message_type}
						{/if}
						{block 'content'}
							content empty
						{/block}
					</div> <!-- .col col-mb-12 col-dt-9 col-padding-bottom -->
				</div> <!-- .content -->
			</div> <!-- .container container-main -->
		</div> <!-- .body-wrapper clearfix -->
		<div class="mobile-nav-wrapper">
			<div class="mobile-nav">
				
			</div>
		</div>

		
		<script src="{$theme}/assets/js/jquery.min.js"></script>
		<script src="{$theme}/assets/js/jquery.matchHeight-min.js"></script>
		<script src="{$theme}/assets/js/jquery.mobileNav.min.js"></script>
		<script src="{$theme}/assets/js/jquery.formstyler.min.js"></script>
		<script src="{$theme}/assets/js/jquery.ladda.min.js"></script>
		<script src="{$theme}/assets/js/jquery.magnificpopup.min.js"></script>
		<script src="{$theme}/assets/js/jquery.form.min.js"></script>
		<script src="{$theme}/assets/js/jquery.mask.min.js"></script>
		<script src="{$theme}/assets/js/main.js"></script>
		
	</body>
</html>