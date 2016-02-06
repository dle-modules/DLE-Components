{* Файл предназначен для формирования меню редактирования вопроса *}

{set $editmenu = []}

{set $editmenu[] = ['name' => "<i class=\"icon-eye\"></i> Список элементов", 'link'=> "{$home}&action=showcomponent&id={$item.id}"]}
{set $editmenu[] = ['name' => "<i class=\"icon-paper\"></i> Код для вставки", 'action'=> 'getcode']}
{set $editmenu[] = ['name' => "<i class=\"icon-cog\"></i> Редактировать", 'link'=> "{$home}&action=editcomponent&id={$item.id}"]}
{set $editmenu[] = ['name' => "<i class=\"icon-stack-2\"></i> Дополнительные поля", 'link'=> "{$home}&action=editcomponentfields&id={$item.id}"]}
{set $editmenu[] = ['name' => "<i class=\"icon-trash\"></i> Удалить", 'action'=> 'delete']}


{if $editmenu?} {* https://github.com/fenom-template/fenom/blob/master/docs/ru/operators.md#Операторы-проверки *}
	<div class="editmenu">
		<span class="editmenu-btn"><i class="icon-ellipsis"></i></span>
		<ul class="editmenu-ul">
			{foreach $editmenu as $item}
				{if $item.action!} {* https://github.com/fenom-template/fenom/blob/master/docs/ru/operators.md#Операторы-проверки *}
					<li><span data-edit-action="{$item.action}">{$item.name}</span></li>
				{else}
					<li><span data-target-self="{$item.link}">{$item.name}</span></li>
				{/if}
			{/foreach}
		</ul>
	</div>
{/if}