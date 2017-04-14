function [N_stim, sigmaq_N_stim] = amb_estimate_observ(pr_Rsat, pr_Msat, ...
         ph_Rsat, ph_Msat, pivot, sat, lambda)

% SYNTAX:
%   [N_stim, sigmaq_N_stim] = amb_estimate_observ(pr_Rsat, pr_Msat, ...
%   ph_Rsat, ph_Msat, pivot, sat, lambda);
%
% INPUT:
%   pr_Rsat = ROVER-SATELLITE code-pseudorange
%   pr_Msat = MASTER-SATELLITE code-pseudorange
%   ph_Rsat = ROVER-SATELLITE phase-pseudorange
%   ph_Msat = MASTER-SATELLITE phase-pseudorange
%   pivot = pivot satellite
%   sat = configuration of satellites in view
%   lambda = vector containing GNSS wavelengths for available satellites
%
% OUTPUT:
%   N_stim = linear combination ambiguity estimate
%   sigmaq_N_stim = assessed variances of combined ambiguity
%
% DESCRIPTION:
%   Estimation of phase ambiguities (and of their error variance) by
%   using both phase and code observations (satellite-receiver distance).

%--- * --. --- --. .--. ... * ---------------------------------------------
%               ___ ___ ___
%     __ _ ___ / __| _ | __|
%    / _` / _ \ (_ |  _|__ \
%    \__, \___/\___|_| |___/
%    |___/                    v 0.5.1 beta
%
%--------------------------------------------------------------------------
%  Copyright (C) 2009-2017 Mirko Reguzzoni, Eugenio Realini
%  Written by:       
%  Contributors:     ...
%  A list of all the historical goGPS contributors is in CREDITS.nfo
%--------------------------------------------------------------------------
%
%   This program is free software: you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation, either version 3 of the License, or
%   (at your option) any later version.
%
%   This program is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%   GNU General Public License for more details.
%
%   You should have received a copy of the GNU General Public License
%   along with this program.  If not, see <http://www.gnu.org/licenses/>.
%
%--------------------------------------------------------------------------
% 01100111 01101111 01000111 01010000 01010011
%--------------------------------------------------------------------------

%variables initialization
global sigmaq_cod1

%PIVOT position research
i = find(pivot == sat);

%pivot code observations
pr_RP = pr_Rsat(i);
pr_MP = pr_Msat(i);

%pivot phase observations
ph_RP = ph_Rsat(i);
ph_MP = ph_Msat(i);

%observed code double differences
comb_pr = (pr_Rsat - pr_Msat) - (pr_RP - pr_MP);

%observed phase double differences
comb_ph = (ph_Rsat - ph_Msat) - (ph_RP - ph_MP);

%linear combination of initial ambiguity estimate
N_stim = ((comb_pr - comb_ph .* lambda)) ./ lambda;
sigmaq_N_stim = 4*sigmaq_cod1 ./ lambda.^2;
