function [n_obj_predict, obj_link_idx] = links_reduction(n_obj_predict, obj_link_idx, dist)
    if n_obj_predict <= 1
        return;
    mean_dist = zeros(n_obj_predict, 1);
    for i = 1 : n_obj_predict
        mean_dist(i) = mean(mean(dist(obj_link_idx{i}, obj_link_idx{i})));
    end
    for i = 1 : n_obj_predict - 1
        for j = i + 1 : n_obj_predict
            cur_dist = dist(obj_link_idx{i}, obj_link_idx{j});
            ---------

end

