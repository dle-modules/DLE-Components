{extends 'app.tpl'}

{block 'content'}
	<div class="content col-margin-bottom">
		<div class="col col-mb-12 col-6 col-dt-8">
			<div class="h3 m0">{$element.name}</div>
		</div>
		<div class="col col-mb-12 col-6 col-dt-4 ta-right">
			<a href="{$home}&action=editelement&componentname={$component.name}&id={$element.id}" class="btn btn-small btn-primry btn-outline"><i class="icon-plus"></i> Редактировать элемент</a>
		</div>
	</div>

	<div class="content content-striped">
		<div class="col col-mb-12 col-5 col-dt-4 col-ld-3 text-light">
			{$config.lang.element.id}
		</div>
		<div class="col col-mb-12 col-7 col-dt-8 col-ld-9">
			{$element.id}
		</div>
	</div>

	<div class="content content-striped">
		<div class="col col-mb-12 col-5 col-dt-4 col-ld-3 text-light">
			{$config.lang.element.name}
		</div>
		<div class="col col-mb-12 col-7 col-dt-8 col-ld-9">
			{$element.name}
		</div>
	</div>

	<div class="content content-striped">
		<div class="col col-mb-12 col-5 col-dt-4 col-ld-3 text-light">
			{$config.lang.element.alt_name}
		</div>
		<div class="col col-mb-12 col-7 col-dt-8 col-ld-9">
			{$element.alt_name}
		</div>
	</div>

	<div class="content content-striped">
		<div class="col col-mb-12 col-5 col-dt-4 col-ld-3 text-light">
			{$config.lang.element.component_name}
		</div>
		<div class="col col-mb-12 col-7 col-dt-8 col-ld-9">
			<a href="{$home}&action=showcomponent&id={$element.component_id}">{$element.component_name}</a>
		</div>
	</div>

	<div class="content content-striped">
		<div class="col col-mb-12 col-5 col-dt-4 col-ld-3 text-light">
			{$config.lang.element.sort_index}
		</div>
		<div class="col col-mb-12 col-7 col-dt-8 col-ld-9">
			{$element.sort_index}
		</div>
	</div>

	<div class="content content-striped">
		<div class="col col-mb-12 col-5 col-dt-4 col-ld-3 text-light">
			{$config.lang.element.image}
		</div>
		<div class="col col-mb-12 col-7 col-dt-8 col-ld-9">
			{$element.image}
		</div>
	</div>

	<div class="content content-striped">
		<div class="col col-mb-12 col-5 col-dt-4 col-ld-3 text-light">
			{$config.lang.element.text}
		</div>
		<div class="col col-mb-12 col-7 col-dt-8 col-ld-9">
			{$element.text}
		</div>
	</div>

	<div class="content content-striped">
		<div class="col col-mb-12 col-5 col-dt-4 col-ld-3 text-light">
			{$config.lang.element.time_create}
		</div>
		<div class="col col-mb-12 col-7 col-dt-8 col-ld-9">
			{$element.time_create}
		</div>
	</div>

	<div class="content content-striped">
		<div class="col col-mb-12 col-5 col-dt-4 col-ld-3 text-light">
			{$config.lang.element.time_update}
		</div>
		<div class="col col-mb-12 col-7 col-dt-8 col-ld-9">
			{$element.time_update}
		</div>
	</div>
	
	
	<div class="content content-striped">
		<div class="col col-mb-12">
			<h3 class="m0">{$config.lang.element.xfields}</h3>
		</div>
	</div>

	{foreach $element.xfields as $xfKey => $xfield}
		<div class="content content-striped">
			<div class="col col-mb-12 col-5 col-dt-4 col-ld-3 text-light">

				<span 
					class="pseudolink btn-field-edit"
					data-mfp-src="{$config.http_home_url}engine/ajax/components/editfield.php"
					data-settings='{ "action": "edit", "componentid": "{$xfield.component_id}", "id": "{$xfield.field_list_id}" }'
				>
					{$xfield.name}
				</span>
				<br>
				<small>
					{$xfield.field_type_description}
				</small>
			</div>
			<div class="col col-mb-12 col-7 col-dt-8 col-ld-9">
				<div class="text-light">
					{if $xfield.display_value|count > 1}
						{$config.lang.xfield.values} ({$xfield.display_value|count}):
					{else}
						{$config.lang.xfield.value}:
					{/if}
				</div>
				{if $xfKey in list ['CHK', 'RAD', 'LIST']}
					{set $listVals = $xfield.default_value|json_decode:'true'}
					{set $selectedVals = $xfield.display_value}
					{set $xfield.display_value = []}
					{foreach $listVals as $listval}
						{if $listval.value in list $selectedVals}
							{set $displayVal = ($listval.label) ? $listval.label : $listval.value}
							{set $xfield.display_value[] = $displayVal}
						{/if}
					{/foreach}
				{/if}
				{if $xfield.display_value|count > 1}
					<ul class="unstyled">
						{foreach $xfield.display_value as $key => $xfValue}
							<li class="xfield-value xfield-type-{$xfield.type|lower}">
								{$xfValue}
							</li>
						{/foreach}
					</ul>
				{else}
					{$xfield.display_value[0]}
				{/if}
				
			</div>
		</div>

	{/foreach}
{/block}

