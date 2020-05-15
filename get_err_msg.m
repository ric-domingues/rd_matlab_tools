function [ err_msg ] = get_err_msg
	st_error = lasterror;
        err_msg = regexprep ( st_error.message, '\n', '; ');
        err_msg = regexprep( err_msg, '==>', '');
