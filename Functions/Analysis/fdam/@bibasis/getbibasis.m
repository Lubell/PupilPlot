[sbasis, tbasis] = getbibasis(bibasisobj);

%  retrieve the two separate basis objects from a bivariate basis object

%  Last modified 13 December 2012

if ~strcmp(class(bibasisobj), 'bibasis')
    error('BIBASISOBJ is not a bibasis object.');
end

if strcmp(getbasistype(bibasisobj), 'product')
    sbasis = bibasisobj.params.sbasis;
    tbasis = bibasisobj.params.tbasis;
else
    error('BIBASISOBJ not of type product.');
end