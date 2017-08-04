function plot(basisobj, nx)
%  Plot a basis object.

%  Last modified 15 July 2015 by Jim Ramsay

typex   = getbasistype(basisobj);
nbasisx = getnbasis(basisobj);

if ~strcmp(typex, 'FEM')
    
    %  set up fine mesh of values
    
    if nargin < 2, nx = max([10*nbasisx+1, 501]);  end
    
    %  evaluate basis at a fine mesh of values
    
    rangex   = getbasisrange(basisobj);
    x        = linspace(rangex(1),rangex(2),nx)';
    basismat = full(eval_basis(x, basisobj));
    
    %  plot the basis values
    
    phdl = plot (x, basismat, '-');
    set(phdl, 'LineWidth', 1);
    
    %  set plotting range
    
    if strcmp(typex, 'bspline')
        minval = 0;
        maxval = 1;
    else
        minval = min(min(basismat));
        maxval = max(max(basismat));
    end
    if minval == maxval
        if abs(minval) < 1e-1
            minval = minval - 0.05;
            maxval = maxval + 0.05;
        else
            minval = minval - 0.05*minval;
            maxval = maxval + 0.05*minval;
        end
    end
    
    %  if the basis is of spline type, plot the knots
    
    if strcmp(typex, 'bspline') || strcmp(typex, 'nspline')
        knots = getbasispar(basisobj);
        hold on
        for k=1:length(knots)
            lhdl = plot([knots(k), knots(k)], [0,1]);
            set(lhdl, 'LineWidth', 1, 'LineStyle', ':', 'color', 'r');
        end
        hold off
    end
    
    xlabel('\fontsize{13} t')
    ylabel('\fontsize{13} \phi(t)')
    titstr = ['\fontsize{16} ', typex, ' basis', ...
        ',  no. basis fns = ', ...
        num2str(nbasisx)];
    if strcmp(typex, 'bspline')
        norderx = nbasisx - length(knots);
        titstr = [titstr, ',  order = ', num2str(norderx)];
    elseif  strcmp(typex, 'nspline')
        norderx = nbasisx - length(knots)+2;
        titstr = [titstr, ',  order = ', num2str(norderx)];
    end
    title(titstr);
    axis([rangex(1), rangex(2), minval, maxval])
    
else
    params = getbasispar(basisobj);
    phdl=triplot(params.t(:,1:3),params.p(:,1),params.p(:,2));
    set(phdl, 'LineWidth', 2)
    hold on
    phdl=plot(params.nodes(:,1),params.nodes(:,2),'o');
    set(phdl, 'LineWidth', 2)
    phdl=plot(params.p(:,1),params.p(:,2),'.');
    set(phdl, 'LineWidth', 2)
    hold off
    xlabel('\fontsize{13} X')
    ylabel('\fontsize{13} Y')
end
