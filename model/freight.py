# -*- encoding: utf-8 -*-
####################################################################################################
#    Module Written to OpenERP, Open Source Management Solution
#
#    Copyright (c) 2013 Jorge Pintor
#    All Rights Reserved.
####################################################################################################
#    Author: DLK Business
#    Coded by: BrandoIsNotASword (triimex-3@hotmail.com)
#              Chidowsky (pintorjorge.52@gmail.com)
####################################################################################################
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
####################################################################################################

from openerp.osv import osv, fields
from datetime import datetime
from openerp.tools.translate import _

def location_name_search(self, cr, user, name='', args=None, operator='ilike', context=None, limit=100):
    if not args:
        args = []

    ids = []
    if len(name) in [2,3]:
        ids = self.search(cr, user, [('code', 'ilike', name)] + args, limit=limit, context=context)

    search_domain = [('name', operator, name)]
    if ids: search_domain.append(('id', 'not in', ids))
    ids.extend(self.search(cr, user, search_domain + args, limit=limit, context=context))

    locations = self.name_get(cr, user, ids, context)
    return sorted(locations, key=lambda (id, name): ids.index(id))

class freight_zone(osv.osv):
    """
    Modelo en donde se guardaran los puertos y aeropuertos en donde la mercacia podra tocar puerta
    segun el usuario, generlmente esto esta representado por el codigo IATA incluso si se habla de
    un puerto
    """

    _name = 'freight.zone'

    _description = "Ciudades IATA"

    def create(self, cursor, user, vals, context=None):
        if vals.get('code'):
            vals['code'] = vals['code'].upper()
        return super(shipment_city, self).create(cursor, user, vals, context=context)

    def name_get(self, cursor, uid, ids, context=None):
        res = []
        for city in self.browse(cursor, uid, ids):
            name=city.name+' ('+city.code+')'
            res.append((city.id, name))
        return res

    _columns = {
        'name': fields.char('Nombre',
            size=50,
            required=True),
        'code': fields.char('Codigo',
            size=3,
            required=True,
            help='Codigo de 3 letras para la ciudad, usualmente el codigo IATA'),
        'state_id': fields.many2one('res.country.state',
            )
        'country': fields.related('state_id','country_id',
            type='many2one',
            relation='shipment.city',
            string='País',
            store=False)
    }

    _sql_constraints = [
        ('code_name_uniq', 'unique (code, name)', 'El codigo de la Ciudad debe ser unico!')
    ]

    _order = 'code'

    name_search = location_name_search


class freight_content(osv.osv):
    """
    Declaracion del modelo del shipment_content el cual es el contenido del Embarque, para esta
    primera version no tendra conexion con almacen o con paquetes, esto para agilizar su
    desarrollo y simplificar su funcionamiento
    """

    _inherit = 'shipment.content'

    _description = "Contenido del Embarque"

    _columns = {
        'insured' : fields.boolean('Asegurado')
    }


freight_content()

class freight(osv.osv):
    """
    Clase principal del modulo, esta clase representa en si el embarque representando
    caracteristcias basicas del mismo.
    """

    _inherit = 'shipment.shipment'

    _description = "Embarques"

    def _calculate_km(self, cr, uid, ids, field_name, arg, context):
        res = {}
        for record in self.browse(cr, uid, ids, context=context):
            res[record.id] = record.end_km - record.start_km
        return res

    def _get_code_flr(self, cr, uid, context, *args):
        obj_sequence = self.pool.get('ir.sequence')
        return obj_sequence.next_by_code(cr, uid, 'freight.sequence', context=context)

    def create(self, cursor, user, vals, context=None):
        if vals.get("shipment_type") == 'domestic':
            vals['name'] = self._get_code_flr(cursor, user, context=context)
        else:
            if vals.get("consolidated") and (not vals.get("parent_id", True) or vals.get("child_ids", False)):
                vals['name'] = self._get_code_master(cursor, user, context=context)
            elif vals['forwarder']:
                vals['name'] = self._get_code_forwarder(cursor, user, context=context)
            else:
                vals['name'] = self._get_code_dlk(cursor, user, context=context)
        return super(shipment, self).create(cursor, user, vals, context=context)

    _columns = {
        'freight_gateway_id': fields.many2one('freight.zone', 'Origen',
            required=False,
            readonly=True,
            states={'draft':[('readonly',False)]}),
        'freight_destination_id': fields.many2one('freight.zone', 'Destino',
            required=False,
            readonly=True,
            states={'draft':[('readonly',False)]}),
        'sender_id' : fields.many2one('res.partner', 'Remitente',
            readonly = True,
            states={'draft':[('readonly',False)]},
            groups='shipment_tracking.group_shipment_user, portal.group_portal'),
        'addresse_id' : fields.many2one('res.partner', 'Destinatario',
            readonly = True,
            states={'draft':[('readonly',False)]},
            groups='shipment_tracking.group_shipment_user, portal.group_portal'),
        'start_km' : fields.float('Km Origen',
            digits=(14,2)),
        'end_km' : fields.float('Km Destino',
            digits=(14,2)),
        'total_km' :  fields.function(_calculate_km,
            string='Km Total',
            store=False,
            type='float',
            method=True,
            readonly=True,
            help="Egresos brutos por el embarque en moneda de la empresa"),
        'customs' : field.char('Aduana',
            size=64,
            readonly=True,
            states={'draft':[('readonly',False)]}),
        'customs_declaration' : fields.many2one('account.invoice', 'Pedimento',
            readonly=True,
            states={'draft':[('readonly',False)]}),
        'operator' : fields.many2one('base.partner', 'Operador',
            readonly = True,
            states={'draft':[('readonly',False)]},
            groups='shipment_tracking.group_shipment_user, portal.group_portal'),
    }

freight()
