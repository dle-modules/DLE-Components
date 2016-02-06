{extends 'app.tpl'}

{block 'content'}
	{* {$arResultVars|d} *}
	<div class="content">
		<div class="col col-mb-12 col-6 col-dt-8">
			<div class="h3 m0">{$component.name} — Список элементов</div>
		</div>
		<div class="col col-mb-12 col-6 col-dt-4 ta-right">
			<a href="{$home}&action=addelement&componentid={$component.id}" class="btn btn-small btn-primry btn-outline"><i class="icon-plus"></i> Добавить элемент</a>
		</div>
	</div>
	<div class="content col-margin">
		{foreach $componentList.items as $item index=$index}
			{if $index > 0}
				<div class="col col-mb-12">
					<hr class="gray">
				</div>
			{/if}
			<div class="col col-mb-12 component-item" id="component-{$item.id}">
				<div class="content">
					<div class="col col-mb-10 col-dt-11">
						<b class="d-ib mr10">
							#{$item.id}
						</b>
						<div class="fz18 d-ib text-primary"><a href="{$home}&action=showcomponent&id={$item.id}">{$item.name}</a> <small class="text-muted" title="Сортировка">({$item.sort_index})</small></div>
						{if $item.text}
							<div>{$item.text}</div>
						{/if}
						
						<div class="content">
							<div class="col col-mb-12">
								<small class="text-muted d-ib mt10">Добавлено: {$item.time_create}</small>
							</div>
						</div>
					</div>
					<div class="col col-mb-2 col-dt-1 ta-right">
						{insert '/actions/menu_components.tpl'}
					</div>
				</div>
			</div>						
		{/foreach}
	</div>
	{if $componentList.count > 0}
		{* Подключаем постраничную навигацию *}
		{include '/actions/pagination.tpl' count=$componentList.count}
	{/if}

{/block}

