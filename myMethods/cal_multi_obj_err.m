function [err, traces_] = cal_multi_obj_err(gridLabel_, traces)
    [t, ~, n] = size(traces);
    per = perms(1 : n);
    [x, y] = label2xy(gridLabel_);
    err = zeros(t, 1);
    for i = 1 : t
        cur_x = x(i, :);
        cur_y = y(i, :);
        real_x = traces(i, 1, :); real_x = real_x(:)';
        real_y = traces(i, 2, :); real_y = real_y(:)';
        per_opt = per(1, :);
        err_opt = 100000;
        for j = 1 : size(per, 1)
            tmp_x = cur_x(per(j, :));
            tmp_y = cur_y(per(j, :));
            tmp_err = sqrt((tmp_x - real_x).^2 + (tmp_y - real_y).^2);
            tmp_err = mean(tmp_err);
            if tmp_err < err_opt
                err_opt = tmp_err;
                per_opt = per(j, :);
            end
        end
        err(i) = err_opt;
        traces_(i, 1, :) = cur_x(per_opt);
        traces_(i, 2, :) = cur_y(per_opt);
    end
end

