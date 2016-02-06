// Определяем переменную для экономии памяти.
var $doc = $(document),
	laddaLoad;

$doc
	// Псевдо-ссылки 2.0
	// для открытия "ссылки" в текущем окне
	.on('click', '[data-target-self]', function (e) {
		var url = $(this).data('targetSelf');
		if (e.metaKey || e.ctrlKey || e.button === 1) {
			window.open(url);
		} else {
			location = url;
		}
	})
	// для открытия "ссылки" в новом окне
	.on('click', '[data-target-blank]', function () {
		window.open($(this).data('targetBlank'));
	})
	.on('click touchend', '[data-click-target]', function (e) {
		// Эмулируем клик по другому элементу
		e.preventDefault();
		var $target = $($(this).data('clickTarget'));
		if (e.type == 'touchend') {
			doc.off('click', $target);
		};
		$target.trigger('click');
	})
	// Меню редактирования
	.on('click', '.editmenu-btn', function(event) {
		event.preventDefault();
		var $this = $(this),
			$parent = $this.closest('.editmenu');

		if ($parent.hasClass('opened')) {
			$parent.removeClass('opened');
		} else {
			$('.editmenu').removeClass('opened');
			$parent.addClass('opened');
		}
	})
	// Закрываем меню редактирования при клике мимо него
	.on('click', 'body', function(e) {
		if ($(e.target).closest('.editmenu-ul').length || $(e.target).closest('.editmenu-btn').length) {
			return;
		}
		$('.editmenu').removeClass('opened');
	})
	.on('click', '.btn-field-edit', function (e) {
		e.preventDefault();
		var $data = $(this).data();

		$.magnificPopup.open({
			items: {
				src: $data.mfpSrc
			},
			type: 'ajax',
			ajax: {
				settings: {
					data: $data.settings
				},
				cursor: 'mfp-ajax-cur'
			}
		});

	})
	// Аякс отправка формы с эффектами
	.on('submit', '[data-ajax-submit]', function () {
		var $this = $(this),
			options = {
				beforeSubmit: processStart,
				success: processDone
			};

		$this.ajaxSubmit(options);

		return false;
	});


// Одинаковая высота блоков
$('.equal').matchHeight();


$.simpleMobileNav({
	navBlock: '.left-nav',
	navContainer: '.mobile-nav',
	navWrapper: '.mobile-nav-wrapper',
	// Колбэки раскомментировать при необходимости
	onInit: function (nav) {
		var $ul = $(nav).find('.left-nav');

		$ul.removeClass('left-nav');
	},
	// onNavToggle: function (nav) {
	// 	console.log('onNavToggle: ', this, nav);
	// },
	// beforeNavOpen: function (nav) {
		// console.log('beforeNavOpen: ', this, nav);
	// },
	// beforeNavClose: function (nav) {
	// 	console.log('beforeNavClose: ', this, nav);
	// }
});

// Стилизация селектов
$('.styler').styler({
	selectSearch: true,
	selectSearchLimit: 20,
	onSelectOpened: function() {
		// к открытому применяем плагин стилизации скроллбара
		// $(this).find('ul').perfectScrollbar();
	}
});


// Дефолтные настройки magnificpopup
$.extend(true, $.magnificPopup.defaults, {
	tClose: 'Закрыть (Esc)',
	tLoading: 'Загрузка...',		
	ajax: {
		tError: 'Контент не загружен.'
	}
});




function processStart(formData, jqForm) {
	laddaLoad = jqForm.find('.ladda-button').ladda();
	laddaLoad.ladda('start');

	return true;
}


function processDone(responseText, statusText, xhr, $form) {

	var $responseText = $(responseText),
		responseResult = ($responseText.is('form')) ? $responseText.html() : responseText;

	var progress = 0;
	var interval = setInterval(function () {
		progress = Math.min(progress + Math.random() * 0.2, 1);
		laddaLoad.ladda('setProgress', progress);

		if (progress === 1) {
			laddaLoad.ladda('stop');
			clearInterval(interval);

			// Тут что-то делаем с пришедшими данными
			if (statusText == 'success') {
				$form.html(responseResult);
			}
		}
	}, 100);
}