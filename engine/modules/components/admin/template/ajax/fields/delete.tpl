<div class="cn-modal col-mb-8 col-7 col-dt-6">
	<div class="cn-modal-content clearfix">
		{if $error}
			<div class="content">
				<div class="col col-mb-12">
					<div class="alert alert-error col-margin-top">
						<ul class="m0">
							{foreach $errors as $err}
								<li>{$err}</li>
							{/foreach}
						</ul>
					</div>
				</div>
			</div>
		{else}
			<div class="alert alert-success">
				Дополнительное поле <b>{$arField.name}</b> удалено!
			</div>
		{/if}
		<div class="col-margin-top ta-center">
			<span class="btn btn-location-reload">Закрыть окно</span>
		</div>
	</div>
</div>