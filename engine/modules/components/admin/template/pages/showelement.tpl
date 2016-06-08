{extends 'app.tpl'}

{block 'content'}
	<pre>{$element|dump}</pre>
	<div class="content">
		<div class="col col-mb-12 col-6 col-dt-8">
			<div class="h3 m0">{$element.name}</div>
		</div>
		<div class="col col-mb-12 col-6 col-dt-4 ta-right">
			<a href="{$home}&action=addelement&componentname={$element.name}" class="btn btn-small btn-primry btn-outline"><i class="icon-plus"></i> Редактировать элемент</a>
		</div>
	</div>
{/block}

