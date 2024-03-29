class NoDataStrings {
  final String noViewRideFound;
  final String noTimerSheetFound;
  final String noReasonFound;
  final String noNotificationFound;
  final String noAddressListFound;
  final String noSupportListFound;
  final String noAccountAndPaymentFound;
  final String noDisputeFound;
  final String noMyDisputeFound;
  final String noRideSummaryFOund;
  final String noAboutListFound;
  final String noDataFound;
  final String addAddress;
  final String addBank;
  final String noBank;

  const NoDataStrings({
    this.noRideSummaryFOund = 'No ride summary found.',
    this.noViewRideFound = "No ride history found.",
    this.noTimerSheetFound = "No summary timesheet found.",
    this.noNotificationFound = "No notification data found.",
    this.noReasonFound = "No reason found yet",
    this.noDisputeFound = "You did not take any rides \nin last 4 hours.",
    this.noSupportListFound = "No support list found yet",
    this.noAccountAndPaymentFound = "No account and paymennt list found yet",
    this.noAboutListFound = "No about data found",
    this.noDataFound = "No data found",
    this.noMyDisputeFound = "Great, there is no dispute \nraised yet.",
    this.noAddressListFound = "You have not added any address",
    this.addAddress = "Add an address to view on addresslist.",
    this.addBank = "Add your bank details",
    this.noBank = "Please enter bank details to view them.",
  });
}
