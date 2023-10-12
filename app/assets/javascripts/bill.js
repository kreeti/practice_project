$(document).ready(function() {
  // Adding BillItem's row on clicking *add more items* link.
  $('form').on('click', '.add_fields', function(e) {
    var regexp, time;
    time = new Date().getTime();
    regexp = new RegExp($(this).data('id'), 'g');
    $('.fields').append($(this).data('fields').replace(regexp, time));

    if(billing.gstStatusRefVal() == 'false') {
      $('table tbody tr:last').find('input[name*="[amount_before_tax]"]').parents('td').addClass('hide');
      $('table tbody tr:last').find('input[name*="[cgst]"]').parents('td').addClass('hide');
      $('table tbody tr:last').find('input[name*="[sgst]"]').parents('td').addClass('hide');
      $('table tbody tr:last').find('input[name*="[igst]"]').parents('td').addClass('hide');
    } else {
      $('table tbody tr:last').find('input[name*="[amount_before_tax]"]').parents('td').removeClass('hide');
      $('table tbody tr:last').find('input[name*="[cgst]"]').parents('td').removeClass('hide');
      $('table tbody tr:last').find('input[name*="[sgst]"]').parents('td').removeClass('hide');
      $('table tbody tr:last').find('input[name*="[igst]"]').parents('td').removeClass('hide');
    }

    e.preventDefault();
  });

  // Removing BillItem's row on clicking *delete button icon*.
  $('form').on('click', '.remove_record', function(e) {
    $(this).prev('input[type=hidden]').val('1');
    $(this).closest('tr').addClass('hide');
    billing.totalPriceCalc();
    e.preventDefault();
  });

  // Changing Bill-form depending on *Bill gst_status*.
  $('input[name="bill[is_gst]"]').on('change', function() {
    billing.gstStatusHandler($(this).val());
    billing.totalPriceCalc();
  });
});


const billing = {
  // Getting Bill gst_status value on checked *is_gst radio button*.
  gst_status_ref_val: function() {
    const checkedTypeVal = '';
    $('input[name="bill[is_gst]"]').each(function() {
      if ( $(this).is(':checked') ) {
        checkedTypeVal = $(this).val();
      }
    });
    return checkedTypeVal;
  },

  // Bill gst_status change effects in Bill-form.
  gstStatusHandler: function(is_gst) {
    if (is_gst == 'false') {
      $('table tr:first').find('th.amount_before_tax').addClass('hide');
      $('table tr input[name*="[amount_before_tax]"]').each(function() {
        $(this).parents('td').addClass('hide');
        $(this).attr('min', 0);
      });

      $('table tr:first').find('th.cgst').addClass('hide');
      $('table tr input[name*="[cgst]"]').each(function() {
        $(this).parents('td').addClass('hide');
      });

      $('table tr:first').find('th.sgst').addClass('hide');
      $('table tr input[name*="[sgst]"]').each(function() {
        $(this).parents('td').addClass('hide');
      });

      $('table tr:first').find('th.igst').addClass('hide');
      $('table tr input[name*="[igst]"]').each(function() {
        $(this).parents('td').addClass('hide');
      });

      $('table tr input[name*="[amount]"]').each(function() {
        $(this).removeAttr('readonly');
      });

      $('table tfoot.form tr:last').find('td:first').attr('colspan', '1').find('a').removeClass('hide');

      $('input[name*="total_cgst"]').parents('tr').addClass('hide');
      $('input[name*="total_sgst"]').parents('tr').addClass('hide');
      $('input[name*="total_igst"]').parents('tr').addClass('hide');

    } else{
      $('table tr:first').find('th.amount_before_tax').removeClass('hide');
      $('table tr input[name*="[amount_before_tax]"]').each(function() {
        $(this).parents('td').removeClass('hide');
        $(this).attr('min', 1);
      });

      $('table tr:first').find('th.cgst').removeClass('hide');
      $('table tr input[name*="[cgst]"]').each(function() {
        $(this).parents('td').removeClass('hide');
      });

      $('table tr:first').find('th.sgst').removeClass('hide');
      $('table tr input[name*="[sgst]"]').each(function() {
        $(this).parents('td').removeClass('hide');
      });

      $('table tr:first').find('th.igst').removeClass('hide');
      $('table tr input[name*="[igst]"]').each(function() {
        $(this).parents('td').removeClass('hide');
      });

      $('table tr input[name*="[amount]"]').each(function() {
        $(this).attr('readonly', 'readonly');
      });

      $('table tfoot.form tr').find('td[colspan="1"]').each(function() {
        $(this).attr('colspan', '5');
      });

      $('table tfoot.form tr:last').find('td:first a').addClass('hide');

      $('table tfoot.form tr').not(':last').each(function() {
        $(this).removeClass('hide');
      });
    }
  },

  // Calculating the amount on changing BillItem row.
  renderAndCalculate: function(link) {
    var productField = $(link).parents('tr').find('textarea[name*="product"]');
    if (productField.val() != '') {
      var beforeAmountField = productField.parents('tr').find('input[name*="[amount_before_tax]"]');
      var amount_before_tax = parseFloat(beforeAmountField.val() === '' ? '0.0' : beforeAmountField.val());

      var cgstField = productField.parents('tr').find('input[name*="cgst"]');
      var cgst = parseFloat(cgstField.val() == '' ? '0.0' : cgstField.val());

      var sgstField = productField.parents('tr').find('input[name*="sgst"]');
      var sgst = parseFloat(sgstField.val() == '' ? '0.0' : sgstField.val());

      var igstField = productField.parents('tr').find('input[name*="igst"]');
      var igst = parseFloat(igstField.val() == '' ? '0.0' : igstField.val());

      var amount = amount_before_tax + cgst + sgst + igst;
      productField.parents('tr').find('input[name*="[amount]"]').val(amount.toFixed(2));

      billing.totalPriceCalc();
    }
  },

  // calculating CGST, SGST, IGST and Total amount.
  totalPriceCalc: function() {
    var totalAmount = 0.0;
    var totalCgst = 0.0;
    var totalSgst = 0.0;
    var totalIgst = 0.0;
    var taxTypeVal = billing.gstStatusRefVal();

    $('.rown').each(function() {
      var amount = $(this).children('td').find('input[name*="[amount]"]').val() || 0.0;

      var cgst = $(this).children('td').find('input[name*="cgst"]').val() || 0.0;
      var sgst = $(this).children('td').find('input[name*="sgst"]').val() || 0.0;
      var igst = $(this).children('td').find('input[name*="igst"]').val() || 0.0;

      if ($(this).children('td').find('input[name*="[product]"]').val() != '') {
        var removedElementVal = $(this).children('td').find('input[name*="[_destroy]"]').val();
        if (removedElementVal === 'false') {
          totalAmount += parseFloat(amount);
          if (taxTypeVal === 'true') {
            totalCgst += parseFloat(cgst);
            totalSgst += parseFloat(sgst);
            totalIgst += parseFloat(igst);
          }
        }
      }
    });

    $('input[name="bill[total_cgst]"]').val(totalCgst.toFixed(2));
    $('input[name="bill[total_sgst]"]').val(totalSgst.toFixed(2));
    $('input[name="bill[total_igst]"]').val(totalIgst.toFixed(2));
    $('input[name="bill[total_amount]"]').val(totalAmount.toFixed(2));
  }
}

// *calculationHandler* is called on changing *BillItem's rate in BillItem's row*.
window.calculationHandler = function(link) {
  billing.renderAndCalculate(link);
}

// *amountHandler* is called on changing *BillItem's rate in BillItem's row*.
window.amountHandler = function(link) {
  billing.totalPriceCalc();
}
