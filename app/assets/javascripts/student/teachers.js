$(document).ready(function(){
    $('.dp-date').datepicker({
        format: "MM d, yyyy",
        todayHighlight: true,
        zIndexOffset: 1200
    });

    if($('.dp-date').val() == ''){
        var today = new Date();
        $('#from').datepicker('setDate', today);
        $('#to').datepicker('setDate', today);
    }

    $('.change-candidate').change(function(){
        $('#search-form').submit();
    });

    $('.teacher-item').click(function(){
        var $this = $(this);
        $.getScript($('#schedule_path').val()+'?teacher_id='+$this.data('id'), function (_) {

        });
    });
});