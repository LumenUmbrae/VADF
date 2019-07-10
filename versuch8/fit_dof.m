%# Copyright (C) 2006-2009 Sebastian Schoeps 
%#
%# This file is part of:
%# FIDES - Field Device Simulator
%#
%# FIDES is free software; you can redistribute it and/or modify
%# it under the terms of the GNU General Public License as published by
%# the Free Software Foundation.
%#
%# This program is distributed in the hope that it will be useful,
%# but WITHOUT ANY WARRANTY; without even the implied warranty of
%# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%# GNU General Public License for more details.
%#
%# You should have received a copy of the GNU General Public License
%# along with this program (see the file LICENSE); if not,
%# see <http://www.gnu.org/licenses/>.
%#
%# author: schoeps@math.uni-wuppertal.de

%# -*- texinfo -*- 
%# @deftypefn {Function File} {[@var{idxs}, @var{idxA}, @var{idxV}]=} @
%# fit_dof (@var{xmesh}, @var{ymesh}, @var{zmesh})
%#
%# returns the indeces of existing primary edges, facets and cells, i.e., all
%# objects but those included in the numbering scheme, but not located within
%# the primary grid are removed (e.g. hair edges).
%#
%# Input:
%# @itemize 
%#  @item @var{xmesh} = FIT mesh in x-direction [m]
%#  @item @var{ymesh} = FIT mesh in y-direction [m]
%#  @item @var{zmesh} = FIT mesh in z-direction [m]
%# @end itemize
%#
%# Output:
%# @itemize
%# @item @var{idxs} = indices of existing edges
%# @item @var{idxA} = indices of existing facets
%# @item @var{idxV} = indices of existing volumes
%# @end itemize
%#
%# Example:
%# @example
%# prb.X=1:3; prb.Y=1:2; prb.Z=1:4;
%# [idxs,idxA,idxV]=fit_dof(prb);
%# @end example
%#
%# @end deftypefn

function [idxs,idxA,idxV]=fit_dof(xmesh, ymesh, zmesh)

  %# number of points  
  nx = length(xmesh);
  ny = length(ymesh);
  nz = length(zmesh);
  np = nx*ny*nz;

  %# hair edges
  H_x = [nx:nx:np];
  H_y = [];
  for k = 1:nz
    H_y = [H_y, (k-1)*nx*ny + (ny-1)*nx + [1:nx]];
  end
  H_z = [(nz-1)*nx*ny+1:np];

  %# existing edges
  idxs =  (1:3*np)'; 
  idxs([H_x np+H_y 2*np+H_z])=[];
  
  %# existing facets
  idxA =  (1:3*np)'; 
  idxA([H_y H_z np+[H_x H_z] 2*np+[H_x H_y] ])=[];
  
  %# existing volumes
  idxV =  (1:np)'; 
  idxV([H_x H_y H_z])=[];

end %function

%!
%!# detailed comparison with a simple example
%!test
%!  prb.X=1:2; prb.Y=1:2; prb.Z=1:2;
%!  [idxs,idxA,idxV]=fit_dof(prb.X,prb.Y,prb.Z);
%!  assert (idxs,[1 3 5 7 9 10 13 14 17 18 19 20]');
%!  assert (idxA,[1 2 9 11 17 21]');
%!  assert (idxV,[1]);
%!
%!# check the number of edges with a bigger example
%!test
%!  prb.X=1:8; prb.Y=1:10; prb.Z=1:6;
%!  nx = length(prb.X); ny = length(prb.Y); nz = length(prb.Z);
%!  [idxs,idxA,idxV]=fit_dof(prb.X,prb.Y,prb.Z);
%!  assert (size(idxs,1),(nx-1)*ny*nz+nx*(ny-1)*nz+nx*ny*(nz-1));
%!  assert (size(idxA,1),nx*(ny-1)*(nz-1)+(nx-1)*ny*(nz-1)+(nx-1)*(ny-1)*nz);
%!  assert (size(idxV,1),(nx-1)*(ny-1)*(nz-1));