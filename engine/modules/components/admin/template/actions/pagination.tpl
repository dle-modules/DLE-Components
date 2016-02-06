{if $count > $pagerConfig['items_per_page']}
	<div class="container container-pagination">
		<div class="content">
			<div class="col col-mb-12">
				{pages config=$pagerConfig total=$count}
			</div> <!-- .col col-mb-12 -->
		</div> <!-- .content -->
	</div> <!-- .container container-pagination -->	
{/if}