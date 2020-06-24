%
function u = blasius_inflow(y,d99)

if(d99==1) % \d_99 = 0.25
	y_in  = 0.095;
	y_out = 0.32;
	y_buf = 0.02;

	ux_in  = (-5.2443*y.^2 + 6.7224*y );
	ux_mid = ( 35.401*y.^4 + 16.752*y.^3 - 32.97*y.^2 + 11.484*y - 0.2193 );
	ux_out = 1.0+0*y;
elseif(d99==2) % \d_99 = 2.00
	y_in  = 0.79;
	y_out = 2.59;
	y_buf = 0.02;
	
	ux_in = -0.0817*y.^2 + 0.8391*y;
	ux_mid = 0.0086*y.^4 + 0.0326*y.^3 - 0.5137*y.^2 + 1.4335*y - 0.2193;
	ux_out = 1.0 +0*y;
else % constant
	y_in  = 0.79;
	y_out = 2.59;
	y_buf = 0.02;
	
	ux_in  = 1.0;
	ux_mid = 1.0;
	ux_out = 1.0;
end


w0i = (y-(y_in -y_buf)) ./ ((y_in +y_buf)-(y_in -y_buf)); w1i = 1.0 - w0i;
w0o = (y-(y_out-y_buf)) ./ ((y_out+y_buf)-(y_out-y_buf)); w1o = 1.0 - w0o;

I_in  = (y<(y_in -y_buf));
I_ibf = (y<(y_in +y_buf))                 - I_in;
I_mid = (y<(y_out-y_buf))         - I_ibf - I_in;
I_obf = (y<(y_out+y_buf)) - I_mid - I_ibf - I_in;
I_out = (y>(y_out+y_buf));

u =     I_in  .* ux_in ; u = u + I_ibf .* (w1i.*ux_in  + w0i.*ux_mid);
u = u + I_mid .* ux_mid;
u = u + I_obf .* (w1o.*ux_mid + w0o.*ux_out);
u = u + I_out .* ux_out;

