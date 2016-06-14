{set $isEdit = false}
{if $.get.action == 'editelement'}
	{set $isEdit = true}
{/if}
{* <pre>
	{$component|dump}
</pre> *}
<div class="content col-margin">
	{if $element.error}
		<div class="col col-mb-12">
			<div class="alert alert-error col-margin-bottom">
				<p>
					<b>{$config.lang.text.errorHeader}</b>
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
		<pre>
			{* {$component|dump} *}
		</pre>
		<form  method="POST">
			<div class="content">
				<div class="col col-mb-12">
					<div class="h4 mb0 text-primary">
						{$config.lang.element.name}
					</div>
					<input class="input input-block {if $element.errors.name!}input-error{/if}" type="text" name="name" value="{$element.name}" title="{$config.lang.element.name}">
				</div>

				<div class="col col-mb-12 col-6">
					<div class="h4 mb0 text-primary">{$config.lang.element.alt_name}</div>
					<div class="text-light">
						<small>Введите название элемента, на английском языке</small>
					</div>
					<input class="input input-block input-mask-latin {if $element.errors.alt_name!}input-error{/if}" type="text" name="alt_name" value="{$element.alt_name}" title="{$config.lang.element.alt_name}">
				</div>

				<div class="col col-mb-12 col-6">
					<div class="h4 mb0 text-primary">{$config.lang.element.sort_index}</div>
					<div class="text-light">
						<small>Чем меньше число - тем выше компонент в списке</small>
					</div>
					{set $sort_index = $element.sort_index > 0 ? $element.sort_index : 500}
					<input class="input input-block {if $element.errors.sort_index!}input-error{/if}" type="number" name="sort_index" value="{$sort_index}" title="{$config.lang.element.sort_index}">
				</div>
				
				<div class="col col-mb-12">
					<div class="h4 mb0 text-primary">{$config.lang.element.text}</div>
					<textarea class="input input-block" name="text" cols="10" title="{$config.lang.element.text}">{$element.text}</textarea>
				</div>

				<div class="col col-mb-12">
					<h3 class="m0">
						{$config.lang.element.xfields}
					</h3>
				</div>
				<div class="col col-mb-12">
					{foreach $component.xfields as $arField}
						{include '/actions/showfieldtype.tpl' field=$arField}
					{/foreach}
				</div>
			</div> <!-- .content -->



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

