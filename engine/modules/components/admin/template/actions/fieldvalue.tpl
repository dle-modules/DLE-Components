{switch $arField.type}
	{case 'TXT'}
		<input class="input input-block" type="text" name="default_value" value="{$arField.default_value}">

	{case 'NUM'}
		<input class="input input-block input-mask-price" type="text" name="default_value" value="{$arField.default_value}" placeholder="000.00">
	
	{case 'TXTM'}
		<textarea class="input input-block" name="default_value">{$arField.default_value}</textarea>

	{case 'INT'}
		<input class="input input-block" type="number" name="default_value" value="{$arField.default_value}">
	
	{case 'FILE'}
		<div class="tip fz14">Для полей типа "файл" не может быть значения по умолчанию</div>
	
	{case 'LIST'}
		<p class="tip fz14">
			Для допполя типа "Список" указывать значениие и отображаемый текст <br>т.к. на странице допполе будет отображаться примерно так: <br>
			<code>&lt;option value="[значение]"&gt;[отображаемый текст]&lt;/option&gt;</code>
		</p>
	{case 'CHK'}
		<p class="tip fz14">
			Для допполя типа "Чекбокс" следует указывать значениие и отображаемый текст <br>т.к. на странице допполе будет отображаться примерно так: <br>
			<code>&lt;input type="checkbox" value="[значение]"&gt;[отображаемый текст]</code>			
		</p>
	{case 'RAD'}
		<p class="tip fz14">
			Для допполя типа "Радиокнопка" следует указывать значениие и отображаемый текст <br>т.к. на странице допполе будет отображаться примерно так: <br>
			<code>&lt;input type="radio" value="[значение]"&gt;[отображаемый текст]</code>			
		</p>
	{case 'LIST', 'CHK', 'RAD'}
		{if $arField.default_value is not array}
			{set $arField.default_value = [$arField.default_value]}
		{/if}
		
		{foreach $arField.default_value as $key => $value first = $first}
			<div class="content">
				<div class="col col-mb-12 col-4 col-dt-4">
					<input class="input input-block input-mask-latin" type="text" name="default_value[{$key}][value]" value="{$value.value}" placeholder="Значение" required>
				</div>
				<div class="col col-mb-12 col-5 col-dt-6">
					<input class="input input-block" type="text" name="default_value[{$key}][label]" value="{$value.label}" placeholder="Отображаемый текст">
				</div>
				<div class="col col-mb-12 col-3 col-dt-2">
					<span class="btn btn-secondary btn-outline btn-block fz14 pl0 pr0" {if $first}disabled{/if} data-remove-list-field title="Удалить текущее поле"><i class="icon-cross"></i> Удалить</span>
				</div>
				<div class="col col-mb-12 col-mb-block col-hide col-dt-hide col-ld-hide"><hr ></div>
			</div>
		{/foreach}

		<a href="#" class="btn btn-outline mt10" data-add-list-field="{$arField.default_value|count}" title="Добавить ещё одно значение"><i class="icon-plus"></i> Добавить значение</a>

	{case 'DATE'}
		<input class="input input-block" type="date" name="default_value" value="{$arField.default_value}" placeholder="дд.мм.гггг">
	
	{case 'NID'}
		<input class="input input-block" type="number" name="default_value" value="{$arField.default_value}" placeholder="Укажите ID новости">
	
	{case 'CID'}
		<input class="input input-block" type="number" name="default_value[component]" value="{$arField.default_value.component}" placeholder="Укажите ID компонента">
		<input class="input input-block" type="number" name="default_value[element]" value="{$arField.default_value.element}" placeholder="Укажите ID элемента">

	{case 'IMG'}
		{* <div class="tip fz14">
			Для полей типа "картинка" не может быть значения по умолчанию, но можно задать необходимые параметры обработки картинки
		</div>

		<div class="col-margin">
			<input class="radio" type="radio" id="img_radio1" name="default_value[imageParams]" value="dle" {if $arField.default_value.imageParams == 'dle'}checked{/if}><label for="img_radio1"><span></span> Обработка картинок средствами DLE</label> <br>
			<input class="radio" type="radio" id="img_radio2" name="default_value[imageParams]" value="custom" {if $arField.default_value.imageParams == 'custom'}checked{/if}><label for="img_radio2"><span></span> Установить собственные правила обработки картинок</label>
		</div> *}
		
		<div class="alert alert-error">
			Функционал настройки картинок пока в разработке
		</div>

	{case default}
		{* code *}
{/switch}