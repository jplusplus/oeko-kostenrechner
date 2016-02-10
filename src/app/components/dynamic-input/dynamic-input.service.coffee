angular.module 'oekoKostenrechner'
  .service 'DynamicInput', (DYNAMIC_INPUT)->
    class DynamicInput
      FIELD_INTERVAL = /(\w+)\.\.(\w+)/
      FIELD_ENUM = /,\w?/g
      FIELD_BOOLEAN = /boolean/
      constructor: (setting, subset)->
        @setSetting setting
        @setSubset subset
      # Basic setters
      setSetting: (setting)=> @setting = setting
      setSubset: (subset={})=> @subset = subset
      # Use a default subset from the instance
      getValues: (subset=@subset)=>
        # Type of the input determines values
        switch do @getType
          # Interval use a specific syntax extract with a regex
          when DYNAMIC_INPUT.FIELD_INTERVAL
            # Define the step between value
            step = 1*@setting.interval or 1
            # We extract the bounds
            [all, floor, ceil] = @setting.values.match(FIELD_INTERVAL)
            # floor and ceil might be dynamic
            floor = if isNaN floor then 1 * @subset[floor] or 0 else 1*floor
            ceil = if isNaN ceil then 1* @subset[ceil] or 10 else 1*ceil
            # The range use a slider
            floor: floor
            ceil: ceil
            step: step
            value: (floor + ceil) / 2
            # And create a range
            range: _.range floor, (ceil + step), step
          # Enumerates literal values
          when DYNAMIC_INPUT.FIELD_ENUM
            # Split using commat and trim space and quotes
            _.map @setting.values.split(','), (v) ->_.trim v, ' "'
          # Booleans enumerates only 2 value (obviously)
          when DYNAMIC_INPUT.FIELD_BOOLEAN then [yes, no]
      getType: =>
        # Test the content of the field's value to know its type.
        switch yes
          # Its an interval of value
          when @setting.hasslider or FIELD_INTERVAL.test @setting.values
            DYNAMIC_INPUT.FIELD_INTERVAL
          # Its a list of value
          when FIELD_ENUM.test @setting.values
            DYNAMIC_INPUT.FIELD_ENUM
          # Its a boolean
          when FIELD_BOOLEAN.test @setting.values
            DYNAMIC_INPUT.FIELD_BOOLEAN