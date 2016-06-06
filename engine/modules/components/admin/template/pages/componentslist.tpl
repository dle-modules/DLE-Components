{extends 'app.tpl'}

{block 'content'}
	{* <pre>{$arTplVars|dump}</pre> *}
	<div class="content">
		<div class="col col-mb-12 col-6">
			<div class="h3 m0">Список компонентов</div>
		</div>
		<div class="col col-mb-12 col-6 ta-right">
			<a href="{$home}&action=addcomponent" class="btn btn-small btn-primry btn-outline"><i class="icon-plus"></i> Добавить компонент</a>
		</div>
	</div>
	<div class="content col-margin">
		{foreach $componentsList.items as $item index=$index}
			{if $index > 0}
				<div class="col col-mb-12">
					<hr class="gray">
				</div>
			{/if}
			<div class="col col-mb-12 component-item" id="component-{$item.id}">
				<div class="content">
					<div class="col col-mb-12 col-6 col-dt-4 equal">
						<b class="d-ib mr10">
							#{$item.id}
						</b>
						<div class="fz18 d-ib text-primary">
							<a href="{$home}&action=showcomponent&id={$item.id}">{$item.name}</a> 
							<small class="text-muted" title="Сортировка">({$item.sort_index})</small>
						</div>
						{if $item.description}
							<div><small>{$item.description}</small></div>
						{/if}
					</div>
					<div class="col col-mb-12 col-6 col-dt-4 equal">
						<small class="text-muted">Дополнительные поля:</small>
						<div>
							{if count($item.fields_list) > 0}
								{foreach $item.fields_list as $field}
									<div class="fz14">
										{$field.name} <span class="text-muted">[{$field.code}]</span>
									</div>
								{/foreach}
							{/if}
						</div>
					</div>
					<div class="col col-mb-12 col-6 col-dt-3 equal">
						<small class="text-muted">Доступ для групп:</small>
						<div class="fz14">
							Чтение: 
							{if $item.read_access}
								{set $_arReadGroups = $item.read_access|split}
								{set $arReadGroups = []}
								{foreach $_arReadGroups as $groupId}

									{set $arReadGroups[] = $arUserGroups[$groupId]['group_name']}
									
								{/foreach}
								{$arReadGroups|join:', '}
							{else}
								Все
							{/if}
							<br>
							Запись: 
							{if $item.write_access}
								{set $_arWriteGroups = $item.write_access|split}
								{set $arWriteGroups = []}
								{foreach $_arWriteGroups as $groupId}
									{set $arWriteGroups[] = $arUserGroups[$groupId]['group_name']}
								{/foreach}
								{$arWriteGroups|join:', '}
							{else}
								Никто
							{/if}
						</div>
					</div>
					<div class="col col-mb-12 col-6 col-dt-1 ta-right equal">
						{insert '/actions/menu_components.tpl'}
					</div>
				</div>
			</div>						
		{/foreach}
	</div>
	{if $componentsList.count > 0}
		{* Подключаем постраничную навигацию *}
		{include '/actions/pagination.tpl' count=$componentsList.count}
	{/if}

{/block}

