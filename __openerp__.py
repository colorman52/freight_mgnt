# -*- encoding: utf-8 -*-
###########################################################################
#    Module Written to OpenERP, Open Source Management Solution
#
#    Copyright (c) 2013 Jorge Pintor
#    All Rights Reserved.
############################################################################
#    Author: Geekyworld
#    Coded by: Chidowsky (pintorjorge.52@gmail.com)
############################################################################
#
#    This program is free software: you can redistribute it and/or modify it under the terms of the
#    GNU Affero General Public License as published by the Free Software Foundation, either version
#    3 of the License, or (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
#    without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#    See the GNU Affero General Public License for more details.
#
#    You should have received a copy of the GNU Affero General Public License along with this
#    program.  If not, see <http://www.gnu.org/licenses/>.
#
##############################################################################

{
	'name': 'Freight Management',
	'author': 'Geekyworld & DLK Business',
    'description': """
Feletes Nacionales
====================

Este modulo tiene como finaliad agregar al modulo 'shipment tracking', el manejo de los fletes nacionales


Visite a DLK Business: http://www.dlkbusiness.com
+++++++++++++++++++++++++++++++++++++++++++++++++
""",
	'website': 'http://geekyworld.net',
	'version': '0.1',
	'depends': [
		'base',
		'mail',
		'sale',
		'portal_anonymous',
		'report_webkit',
		'shipment_tracking',
		'l10n_mx_states'
	],
	'category': 'Logistics',
	'active': False,
	'installable': True,
	'demo_xml': [],
	'init_xml': [
		'data/freight.zone.csv',
		'data/ir.sequence.xml'
	],
	'update_xml': [
		'view/freight_zone_view.xml',
		'view/frieght_view.xml',
		'report/freight_basic_info.xml'
	]
}
