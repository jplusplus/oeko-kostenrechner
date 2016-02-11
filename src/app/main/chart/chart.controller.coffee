angular.module 'oekoKostenrechner'
  .controller 'MainChartController', ($scope, $state, processor)->
    'ngInject'
    new class MainChartController
      constructor: ->
        $scope.$on '$stateChangeSuccess', =>
          # Change chart type according to the current param
          @type = if $state.params.type? then $state.params.type else 'spline'
          @yAxis = if $state.is('main.chart.co2') then 'CO2' else 'TCO'
        # Shortcut to the vehicles created by the user
        @vehicles = $scope.$parent.main.vehicles
        # X-axis available options
        @xAxisOptions = do processor.getXAxisSettings
        # Get default X-axis value
        @xAxis = @xAxisOptions[0].name
        @yAxis = 'TCO'
        @type  = 'spline'
        # Always redirect to child state
        $state.go 'main.chart.tco', type: 'spline'
