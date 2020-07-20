c-----------------------------------------------------------------------
      function blasius_ux(x,y,z,delta99)

      real blasius_ux
      real x,y,z
      integer delta99

      real y_in,y_out,y_buf,ux_in,ux_mid,ux_out,ux,w0,w1

      if(delta99.eq.1) then
        y_in  = 0.095
        y_out = 0.32
        y_buf = 0.02

        ux_in  = (-5.2443*y**2 + 6.7224*y )
        ux_mid = ( 35.401*y**4 + 16.752*y**3 - 32.97*y**2 
     &           + 11.484*y - 0.2193 )
        ux_out = 1.0

      elseif(delta99.eq.2) then
        y_in  = 0.79
        y_out = 2.59
        y_buf = 0.02
  
        ux_in = -0.0817*y**2 + 0.8391*y
        ux_mid = 0.0086*y**4 + 0.0326*y**3 
     &         - 0.5137*y**2 + 1.4335*y - 0.2193
        ux_out = 1.0
  
      else
        y_in  = 0.79
        y_out = 2.59
        y_buf = 0.02
  
        ux_in  = 1.0
        ux_mid = 1.0
        ux_out = 1.0
  
      endif

      if(y .LE. y_in-y_buf) then
         ux = ux_in
      elseif(y .LE. y_in+y_buf) then
         w0 = ( y - (y_in-y_buf) )
     &      / ((y_in+y_buf) - (y_in-y_buf))
         w1 = 1.0 - w0
         ux = w1*ux_in + w0*ux_mid
      elseif(y .LE. y_out-y_buf) then       
         ux = ux_mid
      elseif(y .LE. y_out+y_buf) then
         w0 = ( y - (y_out-y_buf) )
     &      / ((y_out+y_buf) - (y_out-y_buf))
         w1 = 1.0 - w0
         ux = w1*ux_mid + w0*ux_out
      else
         ux = ux_out
      endif

      blasius_ux = ux

      return
      end
c-----------------------------------------------------------------------
