{extends 'app.tpl'}

{block 'content'}
	{* <pre>{$arTplVars|dump}</pre> *}
	<div class="content">
		<div class="col col-mb-12">
			<div class="h3 m0">
				{$config.lang.text.addElement}
			</div>
		</div>
	</div>

	{insert 'forms/element.tpl'}	

{/block}

