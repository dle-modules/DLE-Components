{set $isEdit = false}
{if $.get.action == 'editelement'}
	{set $isEdit = true}
{/if}
<div class="content col-margin">
	{if $element.error}
		<div class="col col-mb-12">
			<div class="alert alert-error col-margin-bottom">
				<p>
					<b>Ошибка</b>
				</p>
				<ul class="m0">
					{foreach $element.errors as $error}
						<li>{$error}</li>
					{/foreach}
				</ul>
			</div>
		</div>
	{/if}
	<div class="col col-mb-12">
		<form  method="POST">
			<div class="content">
				<div class="col col-mb-12 col-6">
					<div class="h4 mb0 text-primary">Название компонента</div>
					<div class="text-light">
						{if $isEdit}
							<small>Название компонента изменять нельзя</small>
						{else}
							<small>Введите название компонента, на английском языке</small>
						{/if}
					</div>
					<input class="input input-block input-mask-latin {if $element.errors.name!}input-error{/if}" type="text" name="name" value="{$element.name}" {if $isEdit}disabled{/if}>
				</div>
				<div class="col col-mb-12 col-6">
					<div class="h4 mb0 text-primary">Индекс сортировки</div>
					<div class="text-light"><small>Чем меньше число - тем выше компонент в списке</small></div>
					<input class="input input-block {if $element.errors.sort_index!}input-error{/if}" type="number" name="sort_index" value="{$element.sort_index}">
				</div>
			</div>

			<div class="h4 mb0 text-primary">Описание компонента</div>
			<div class="text-light"><small>Введите текст, описывающий назначение компонента</small></div>
			<textarea class="input input-block" name="description" cols="10">{$element.description}</textarea>

			<div class="content">
				<div class="col col-mb-12">
					<div class="h4 mb0 text-primary d-ib mr10">Доступ групп к компоненту</div>
					<div class="text-light d-ib"><small>(Администратор всегда имеет полный доступ ко всем компонентам)</small></div>

				</div>
				<div class="col col-mb-12 col-6">
					<div class="fz18 mt10 text-primary">Просмотр элементов</div>
					<div class="text-light"><small>По умолчанию разрешено всем</small></div>
					{foreach $arUserGroups as $key => $group}
						{if $group.id == 1}
							{continue}
						{/if}
						<div>
							<input 
								class="checkbox" 
								type="checkbox" 
								name="read_access[]" 
								value="{$group.id}" 
								id="read_access_{$group.id}"
								{if $group.id in list $selectedReadGroups}
									checked
								{/if}
							>
							<label for="read_access_{$group.id}"><span></span> [{$group.id}] {$group.group_name}</label>
						</div>
					{/foreach}
				</div>
				<div class="col col-mb-12 col-6">
					<div class="fz18 mt10 text-primary">Добавление элементов</div>
					<div class="text-light"><small>По умолчанию запрещено всем</small></div>
					{foreach $arUserGroups as $key => $group}
						{if $group.id == 1 || $group.id == 5}
							{continue}
						{/if}
						<div>
							<input 
								class="checkbox" 
								type="checkbox" 
								name="write_access[]" 
								value="{$group.id}" 
								id="write_access_{$group.id}"
								{if $group.id in list $selectedWriteGroups}
									checked
								{/if}
							>
							<label for="write_access_{$group.id}"><span></span> [{$group.id}] {$group.group_name}</label>
						</div>
					{/foreach}
				</div>
			</div>

			<div class="col-margin-top">
				<hr>
				<button class="btn ladda-button" type="submit" data-style="zoom-out">
					<span class="ladda-label">
						{if $isEdit}
							Сохранить
						{else}
							Добавить
						{/if}
					</span>
				</button>
			</div>
			<input type="hidden" name="add" value="y">

		</form>
	</div>
</div>

