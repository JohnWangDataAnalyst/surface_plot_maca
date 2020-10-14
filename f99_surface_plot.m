function f99_surface_plot(values_leftRight, arealabels, hemispheres, perspective)

% INPUT:
% values_leftRight - values to be visualized, in both hemispheres
% arealabels - cell array of area labels in the same order
% hemispheres - cell array with either 'L' or 'R', in the same order
% perspective - 'medial', 'lateral', or 'dorsal'
% DEPENDENCIES: vertex_data_f99.mat

load /rri_disks/cyrene/mcintosh_lab/kshen/NHP_fMRIonly/CosineSimilarity/vertex_data_f99

vertexValues_l = zeros(size(vertices_areanames));
vertexValues_r = zeros(size(vertices_areanames));
%{
% split data between hemispheres
arealabels_1hem = cell(length(arealabels)/2, 1);
valuesLeft = zeros(length(arealabels)/2, 1);
valuesRight = zeros(length(arealabels)/2, 1);
for i=1:length(arealabels_1hem)    
    arealabels_1hem(i) = strrep(arealabels(i),'_R','');
    valuesLeft(i) = values_leftRight(i);
    valuesRight(i) = values_leftRight(i+length(arealabels_1hem));
end
%}
% handling vertices
vertices_data_l = zeros(length(vertices_areanames),1);
vertices_data_r = zeros(length(vertices_areanames),1);
for i=1:length(vertices_areanames)
    this_label = vertices_areanames(i);
    [truefalse, index] = ismember(arealabels, this_label);
    %truefalse
    %~isempty(nonzeros(truefalse))
    if (~isempty(nonzeros(truefalse)))
        item_index = find(index);
        for j=1:length(item_index)
            this_idx = item_index(j);
            if (strcmp(hemispheres(this_idx),'L'))
                vertices_data_l(i) = values_leftRight(this_idx);
            else
                vertices_data_r(i) = values_leftRight(this_idx);
            end
        end
    else
        vertices_data_l(i) = 0;
        vertices_data_r(i) = 0;
        %keyboard;
    end
end

% plot surface data
colormap_max = max(max(vertices_data_r, vertices_data_l));
colormap_min = min(min(vertices_data_r, vertices_data_l));
% left hemisphere
figure; hold on
vertices_left = vertices;
vertices_left(:,1) = -vertices(:,1);
p = patch('Vertices',vertices_left,'Faces',faces,'FaceVertexCData',vertices_data_l,...
    'FaceColor','flat','FaceColor','interp','FaceLighting','phong',...
    'EdgeColor','none');
h = zoom;
set(h,'Motion','horizontal','Enable','on');
set(gcf,'Renderer','zbuffer');
if strcmp(perspective,'lateral')==1
    view(-90,0);
elseif strcmp(perspective,'medial')==1
    view(90,0);
elseif strcmp(perspective,'dorsal')==1
    view(0, 90);
end
camlight(-40,40);
camlight(-40,40);
%lighting('flat');
material('metal');
alpha(0.5);

daspect([1 1 1]);
axis off image
colorbar
cmap = colormap;
cmap(1,:) = [0 0 0];
colormap(cmap);
caxis([colormap_min colormap_max]);


% right hemisphere
figure; hold on
p = patch('Vertices',vertices,'Faces',faces,'FaceVertexCData',vertices_data_r,...
    'FaceColor','flat','FaceColor','interp','FaceLighting','phong',...
    'EdgeColor','none');
h = zoom;
set(h,'Motion','horizontal','Enable','on');
set(gcf,'Renderer','zbuffer');
if strcmp(perspective,'lateral')==1
    view(90,0);
elseif strcmp(perspective,'medial')==1
    view(-90,0);
elseif strcmp(perspective,'dorsal')==1
    view(0, 90);
end
camlight(-40,40);
camlight(-40,40);
%lighting('flat');
material('metal');
alpha(0.5);

daspect([1 1 1]);
axis off image
colorbar
cmap = colormap;
cmap(1,:) = [0 0 0];
colormap(cmap);
caxis([colormap_min colormap_max]);
