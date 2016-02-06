{extends 'app.tpl'}

{block 'content'}
	{* {$arResultVars|d} *}
	<div class="content">
		<div class="col col-mb-12">
			<div class="h3 m0">{$component.name} — Редактирование компонента</div>
		</div>
	</div>

	{insert 'forms/component.tpl'}	

{/block}

