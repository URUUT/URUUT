function initProjectProgressbar () {
  $('.progressbar_project').each(function(index, el) {
    $(this).progressbar({
      value: parseInt(this.getAttribute('data-value'))
    });
    $(this).find('div').css({ 'background': '#70bf4c' });
  });
};

initProjectProgressbar();
