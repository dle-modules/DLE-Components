{extends 'app.tpl'}

{block 'content'}
	<div class="content">
		<div class="col col-mb-12">
			<div class="h3 m0">Настройки модуля</div>
		</div>
	</div>
	<pre>{$arConfig|dump}</pre>

{/block}