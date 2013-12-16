$(function() {
    
    $('div:not(.site)').hide();
    $('div.contenttype').show();
	$('div.config').show();
	
	if($('.error')) {
		$('.error').parents('div').show();
/*
        $('.error').parents('div').children('div.portlet').show();
		$('.error').parents('div').children('div.pagetemplate').show();
		$('.error').parents('div').children('div.datasource').show();
*/
	}
    $('div').click(function(e) {
        if (e.target != this) return;
        $(this).children('div').slideToggle();
    });
});