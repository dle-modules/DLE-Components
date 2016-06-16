{set $required = $arField.is_required ? ' required ' : ''}

{set $postData = $.post['xfields'][$arField.code]}

<pre>
	{$postData|dump}
</pre>

<div class="content content-striped">
	<div class="col col-mb-12 col-5 col-dt-4 col-ld-3 text-light">

		<span 
			class="pseudolink btn-field-edit"
			data-mfp-src="{$config.http_home_url}engine/ajax/components/editfield.php"
			data-settings='{ "action": "edit", "componentid": "{$arField.component_id}", "id": "{$arField.id}" }'
		>{$arField.name}</span>
		{if $arField.is_required}
			<small class="text-error" title="{$config.lang.xfield.is_required}">*</small>
		{/if}
		{if $arField.description!}
			<br>
			<small>
				{$arField.description}
			</small>
		{/if}
	</div>
	<div class="col col-mb-12 col-7 col-dt-8 col-ld-9">

		{set $arNewFieldValues = $isPost ? $postData : $arField.default_value}

		{if $arNewFieldValues is not array}
			{set $arFieldValues = [$arNewFieldValues]}
		{else}
			{set $arFieldValues = $arNewFieldValues}
		{/if}

		{switch $arField.type}
			{case 'TXT'}
				{if $arField.is_multiple}
					{foreach $arFieldValues as $key => $value first = $first}
						<div class="content">
							<div class="col col-mb-12 col-9 col-dt-10">
								<input class="input input-block" type="text" name="xfields[{$arField.code}][{$key}]" value="{$value}" placeholder="Значение" {$required}>
							</div>
							<div class="col col-mb-12 col-3 col-dt-2">
								<span class="btn btn-secondary btn-outline btn-block fz14 pl0 pr0" {if $first}disabled{/if} data-remove-list-field title="Удалить текущее поле"><i class="icon-cross"></i> Удалить</span>
							</div>
							<div class="col col-mb-12 col-mb-block col-hide col-dt-hide col-ld-hide"><hr ></div>
						</div>
					{/foreach}
					
					<template id="field_template_{$arField.code}">
						<div class="content">
							<div class="col col-mb-12 col-9 col-dt-10">
								<input class="input input-block focusme" type="text" name="xfields[{$arField.code}][[%this.key%]]" value="{$arField.default_value}" placeholder="Значение" {$required}>
							</div>
							<div class="col col-mb-12 col-3 col-dt-2">
								<span class="btn btn-secondary btn-outline btn-block fz14 pl0 pr0" {if $first}disabled{/if} data-remove-list-field title="Удалить текущее поле"><i class="icon-cross"></i> Удалить</span>
							</div>
							<div class="col col-mb-12 col-mb-block col-hide col-dt-hide col-ld-hide"><hr ></div>
						</div>
					</template>

					<a href="#" class="btn btn-outline mt10" data-add-list-field="{$arField.default_value|count}" data-add-list-template="field_template_{$arField.code}" title="Добавить ещё одно значение"><i class="icon-plus"></i> Добавить значение</a>
				{else}
				<pre>
					{$arFieldValues|dump}
				</pre>
					<input class="input input-block" type="text" name="xfields[{$arField.code}]" value="{$arFieldValues[0]}" title="" {$required}>
				{/if}

			{case 'NUM'}
				{if $arField.is_multiple}
					{foreach $arFieldValues as $key => $value first = $first}
						<div class="content">
							<div class="col col-mb-12 col-9 col-dt-10">
								<input class="input input-block input-mask-price" type="text" name="xfields[{$arField.code}][{$key}][value]" value="{$value}" title="" placeholder="000.00" {$required}>
							</div>
							<div class="col col-mb-12 col-3 col-dt-2">
								<span class="btn btn-secondary btn-outline btn-block fz14 pl0 pr0" {if $first}disabled{/if} data-remove-list-field title="Удалить текущее поле"><i class="icon-cross"></i> Удалить</span>
							</div>
							<div class="col col-mb-12 col-mb-block col-hide col-dt-hide col-ld-hide"><hr ></div>
						</div>
					{/foreach}
					
					<template id="field_template_{$arField.code}">
						<div class="content">
							<div class="col col-mb-12 col-9 col-dt-10">
								<input class="input input-block input-mask-price focusme" type="text" name="xfields[{$arField.code}][[key]][value]" value="{$value}" title="" placeholder="000.00" {$required}>
							</div>
							<div class="col col-mb-12 col-3 col-dt-2">
								<span class="btn btn-secondary btn-outline btn-block fz14 pl0 pr0" {if $first}disabled{/if} data-remove-list-field title="Удалить текущее поле"><i class="icon-cross"></i> Удалить</span>
							</div>
							<div class="col col-mb-12 col-mb-block col-hide col-dt-hide col-ld-hide"><hr ></div>
						</div>
					</template>

					<a href="#" class="btn btn-outline mt10" data-add-list-field="{$arField.default_value|count}" data-add-list-template="field_template_{$arField.code}" title="Добавить ещё одно значение"><i class="icon-plus"></i> Добавить значение</a>
				{else}
					<input class="input input-block input-mask-price" type="text" name="xfields[{$arField.code}][value]" value="{$arField.default_value}" title="" placeholder="000.00" {$required}>
				{/if}
			
			{case 'TXTM'}
				{if $arField.is_multiple}
					{foreach $arFieldValues as $key => $value first = $first}
						<div class="content">
							<div class="col col-mb-12 col-9 col-dt-10">
								<textarea class="input input-block focusme" name="xfields[{$arField.code}][{$key}][value]" title="" {$required}>{$value}</textarea>
							</div>
							<div class="col col-mb-12 col-3 col-dt-2">
								<span class="btn btn-secondary btn-outline btn-block fz14 pl0 pr0" {if $first}disabled{/if} data-remove-list-field title="Удалить текущее поле"><i class="icon-cross"></i> Удалить</span>
							</div>
							<div class="col col-mb-12 col-mb-block col-hide col-dt-hide col-ld-hide"><hr ></div>
						</div>
					{/foreach}
					
					<template id="field_template_{$arField.code}">
						<div class="content">
							<div class="col col-mb-12 col-9 col-dt-10">
								<textarea class="input input-block focusme" name="xfields[{$arField.code}][[key]][value]" title="" {$required}>{$value}</textarea>
							</div>
							<div class="col col-mb-12 col-3 col-dt-2">
								<span class="btn btn-secondary btn-outline btn-block fz14 pl0 pr0" {if $first}disabled{/if} data-remove-list-field title="Удалить текущее поле"><i class="icon-cross"></i> Удалить</span>
							</div>
							<div class="col col-mb-12 col-mb-block col-hide col-dt-hide col-ld-hide"><hr ></div>
						</div>
					</template>

					<a href="#" class="btn btn-outline mt10" data-add-list-field="{$arField.default_value|count}" data-add-list-template="field_template_{$arField.code}" title="Добавить ещё одно значение"><i class="icon-plus"></i> Добавить значение</a>
				{else}
					<textarea class="input input-block" name="xfields[{$arField.code}][value]" title="" {$required}>{$arField.default_value}</textarea>
				{/if}
				

			{case 'INT'}
				{if $arField.is_multiple}
					{foreach $arFieldValues as $key => $value first = $first}
						<div class="content">
							<div class="col col-mb-12 col-9 col-dt-10">
								<input class="input input-block" type="number" name="xfields[{$arField.code}][{$key}][value]" value="{$value}" title="" {$required}>
							</div>
							<div class="col col-mb-12 col-3 col-dt-2">
								<span class="btn btn-secondary btn-outline btn-block fz14 pl0 pr0" {if $first}disabled{/if} data-remove-list-field title="Удалить текущее поле"><i class="icon-cross"></i> Удалить</span>
							</div>
							<div class="col col-mb-12 col-mb-block col-hide col-dt-hide col-ld-hide"><hr ></div>
						</div>
					{/foreach}
					
					<template id="field_template_{$arField.code}">
						<div class="content">
							<div class="col col-mb-12 col-9 col-dt-10">
								<input class="input input-block focusme" type="number" name="xfields[{$arField.code}][[key]][value]" value="{$value}" title="" {$required}>
							</div>
							<div class="col col-mb-12 col-3 col-dt-2">
								<span class="btn btn-secondary btn-outline btn-block fz14 pl0 pr0" {if $first}disabled{/if} data-remove-list-field title="Удалить текущее поле"><i class="icon-cross"></i> Удалить</span>
							</div>
							<div class="col col-mb-12 col-mb-block col-hide col-dt-hide col-ld-hide"><hr ></div>
						</div>
					</template>

					<a href="#" class="btn btn-outline mt10" data-add-list-field="{$arField.default_value|count}" data-add-list-template="field_template_{$arField.code}" title="Добавить ещё одно значение"><i class="icon-plus"></i> Добавить значение</a>
				{else}
					<input class="input input-block" type="number" name="xfields[{$arField.code}][value]" value="{$arField.default_value}" title="" {$required}>
				{/if}
			
			{case 'FILE'}
				<div class="alert alert-info">
					Функционал добавления файлов пока в разработке
				</div>			
			
			{case 'LIST', 'CHK', 'RAD', 'CID'}
				{set $fieldDefaultValue = $arField.default_value|json_decode:'true'}

			{case 'LIST'}
				<select class="{if !$arField.is_multiple}styler{else}input{/if} col-mb-min-8 col-min-5 col-dt-min-4" name="xfields[{$arField.code}][value]" {$required} {if $arField.is_multiple}multiple{/if}>
					{foreach $fieldDefaultValue as $key => $field}
						{set $label = $field.label ? $field.label : $field.value}
						<option value="{$field.value}">
							{$label}
						</option>
					{/foreach}
				</select>
				
			{case 'CHK'}
				{foreach $fieldDefaultValue as $key => $field}
					{set $label = $field.label ? $field.label : $field.value}
					<input class="checkbox" type="checkbox" name="xfields[{$arField.code}][value][]" value="{$field.value}" id="checkbox_{$field.vlue}_{$key}" {$required}>
					<label for="checkbox_{$field.vlue}_{$key}"><span></span> {$label}</label>
				{/foreach}

			{case 'RAD'}
				{foreach $fieldDefaultValue as $key => $field}
					{set $label = $field.label ? $field.label : $field.value}
					<input class="radio" type="radio" name="xfields[{$arField.code}][value]" value="{$field.value}" id="radio_{$field.vlue}_{$key}" {$required}>
					<label for="radio_{$field.vlue}_{$key}"><span></span> {$label}</label>
				{/foreach}

			{case 'DATE'}
				{if $arField.is_multiple}
					{foreach $arFieldValues as $key => $value first = $first}
						<div class="content">
							<div class="col col-mb-12 col-9 col-dt-10">
								<input class="input input-block" type="date" name="xfields[{$arField.code}][{$key}][value]" value="{$value}" title="" {$required} placeholder="дд.мм.гггг">
							</div>
							<div class="col col-mb-12 col-3 col-dt-2">
								<span class="btn btn-secondary btn-outline btn-block fz14 pl0 pr0" {if $first}disabled{/if} data-remove-list-field title="Удалить текущее поле"><i class="icon-cross"></i> Удалить</span>
							</div>
							<div class="col col-mb-12 col-mb-block col-hide col-dt-hide col-ld-hide"><hr ></div>
						</div>
					{/foreach}
					
					<template id="field_template_{$arField.code}">
						<div class="content">
							<div class="col col-mb-12 col-9 col-dt-10">
								<input class="input input-block focusme" type="date" name="xfields[{$arField.code}][[key]][value]" value="{$value}" title="" {$required} placeholder="дд.мм.гггг">
							</div>
							<div class="col col-mb-12 col-3 col-dt-2">
								<span class="btn btn-secondary btn-outline btn-block fz14 pl0 pr0" {if $first}disabled{/if} data-remove-list-field title="Удалить текущее поле"><i class="icon-cross"></i> Удалить</span>
							</div>
							<div class="col col-mb-12 col-mb-block col-hide col-dt-hide col-ld-hide"><hr ></div>
						</div>
					</template>

					<a href="#" class="btn btn-outline mt10" data-add-list-field="{$arField.default_value|count}" data-add-list-template="field_template_{$arField.code}" title="Добавить ещё одно значение"><i class="icon-plus"></i> Добавить значение</a>
				{else}
					<input class="input input-block" type="date" name="xfields[{$arField.code}][value]" value="{$arField.default_value}" title="" {$required} placeholder="дд.мм.гггг">
				{/if}
			
			{case 'NID'}
				{if $arField.is_multiple}
					{foreach $arFieldValues as $key => $value first = $first}
						<div class="content">
							<div class="col col-mb-12 col-9 col-dt-10">
								<input class="input input-block" type="number" name="xfields[{$arField.code}][{$key}][value]" value="{$value}" title="" {$required} placeholder="Укажите ID новости">
							</div>
							<div class="col col-mb-12 col-3 col-dt-2">
								<span class="btn btn-secondary btn-outline btn-block fz14 pl0 pr0" {if $first}disabled{/if} data-remove-list-field title="Удалить текущее поле"><i class="icon-cross"></i> Удалить</span>
							</div>
							<div class="col col-mb-12 col-mb-block col-hide col-dt-hide col-ld-hide"><hr ></div>
						</div>
					{/foreach}
					
					<template id="field_template_{$arField.code}">
						<div class="content">
							<div class="col col-mb-12 col-9 col-dt-10">
								<input class="input input-block focusme" type="number" name="xfields[{$arField.code}][[key]][value]" value="{$value}" title="" {$required} placeholder="Укажите ID новости">
							</div>
							<div class="col col-mb-12 col-3 col-dt-2">
								<span class="btn btn-secondary btn-outline btn-block fz14 pl0 pr0" {if $first}disabled{/if} data-remove-list-field title="Удалить текущее поле"><i class="icon-cross"></i> Удалить</span>
							</div>
							<div class="col col-mb-12 col-mb-block col-hide col-dt-hide col-ld-hide"><hr ></div>
						</div>
					</template>

					<a href="#" class="btn btn-outline mt10" data-add-list-field="{$arField.default_value|count}" data-add-list-template="field_template_{$arField.code}" title="Добавить ещё одно значение"><i class="icon-plus"></i> Добавить значение</a>
				{else}
					<input class="input input-block" type="number" name="xfields[{$arField.code}][value]" value="{$arField.default_value}" title="" {$required} placeholder="Укажите ID новости">
				{/if}
			
			{case 'CID'}

				{if $arField.is_multiple}
					{foreach $arFieldValues as $key => $value first = $first}
						<div class="content">
							<div class="col col-mb-12 col-9 col-dt-10">
								<div class="content">
									<div class="col col-mb-12 col-6">
										<input class="input input-block" type="number" name="xfields[{$arField.code}][{$key}][value][component]" value="{$fieldDefaultValue.component}" placeholder="Укажите ID компонента" {$required}>
									</div>
									<div class="col col-mb-12 col-6">
										<input class="input input-block" type="number" name="xfields[{$arField.code}][{$key}][value][element]" value="{$fieldDefaultValue.element}" placeholder="Укажите ID элемента" {$required}>
									</div>
								</div>
							</div>
							<div class="col col-mb-12 col-3 col-dt-2">
								<span class="btn btn-secondary btn-outline btn-block fz14 pl0 pr0" {if $first}disabled{/if} data-remove-list-field title="Удалить текущее поле"><i class="icon-cross"></i> Удалить</span>
							</div>
							<div class="col col-mb-12 col-mb-block col-hide col-dt-hide col-ld-hide"><hr ></div>
						</div>
					{/foreach}
					
					<template id="field_template_{$arField.code}">
						<div class="content">
							<div class="col col-mb-12 col-9 col-dt-10">
								<div class="content">
									<div class="col col-mb-12 col-6">
										<input class="input input-block" type="number" name="xfields[{$arField.code}][[key]][value][component]" value="{$fieldDefaultValue.component}" placeholder="Укажите ID компонента" {$required}>
									</div>
									<div class="col col-mb-12 col-6">
										<input class="input input-block" type="number" name="xfields[{$arField.code}][[key]][value][element]" value="{$fieldDefaultValue.element}" placeholder="Укажите ID элемента" {$required}>
									</div>
								</div>
							</div>
							<div class="col col-mb-12 col-3 col-dt-2">
								<span class="btn btn-secondary btn-outline btn-block fz14 pl0 pr0" {if $first}disabled{/if} data-remove-list-field title="Удалить текущее поле"><i class="icon-cross"></i> Удалить</span>
							</div>
							<div class="col col-mb-12 col-mb-block col-hide col-dt-hide col-ld-hide"><hr ></div>
						</div>
					</template>

					<a href="#" class="btn btn-outline mt10" data-add-list-field="{$arField.default_value|count}" data-add-list-template="field_template_{$arField.code}" title="Добавить ещё одно значение"><i class="icon-plus"></i> Добавить значение</a>
				{else}
					<div class="content">
						<div class="col col-mb-12 col-6">
							<input class="input input-block" type="number" name="xfields[{$arField.code}][value][component]" value="{$fieldDefaultValue.component}" placeholder="Укажите ID компонента" {$required}>
						</div>
						<div class="col col-mb-12 col-6">
							<input class="input input-block" type="number" name="xfields[{$arField.code}][value][element]" value="{$fieldDefaultValue.element}" placeholder="Укажите ID элемента" {$required}>
						</div>
					</div>
				{/if}

			{case 'IMG'}
			
				<div class="alert alert-info">
					Функционал добавления картинок пока в разработке
				</div>
		{/switch}	
	</div>
</div>

