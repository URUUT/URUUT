function initProjectProgressbar () {
  $('.progressbar_project').each(function(index, el) {
    var color = this.getAttribute('data-color') || '#70bf4c';
    $(this).progressbar({
      value: parseInt(this.getAttribute('data-value'))
    });
    $(this).find('div').css({ 'background': color });
  });
};

initProjectProgressbar();
