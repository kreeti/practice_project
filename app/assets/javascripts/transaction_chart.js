$(function() {
  $('#transaction_chart').on('load', TransactionChart.displayChart());
});

TransactionChart = {
  displayChart: function() {
      transactions = $("#transaction_chart").data("transaction");
      new Chartkick.ColumnChart("transaction_chart", transactions);
  }
}
