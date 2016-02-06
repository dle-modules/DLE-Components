{* {extends 'app.tpl'}
{block 'content'}
	<div class="content">
		<div class="col col-mb-12 col-6">
			<a href="{$home}&action=componentslist" class="btn btn-primary btn-big btn-block">Список компонентов</a>
		</div>
		<div class="col col-mb-12 col-6">
			<a href="{$home}&action=config" class="btn btn-additional btn-big btn-block">Настроки модуля</a>
		</div>
	</div>	
{/block} *}
	{insert '/pages/componentslist.tpl'}

