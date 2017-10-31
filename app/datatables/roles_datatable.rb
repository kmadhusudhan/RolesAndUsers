class RolesDatatable
	delegate :params, :h, :link_to, :number_to_currency, to: :@view

	def initialize(view)
		@view = view
	end

	def as_json(options = {})
		{
			sEcho: params[:sEcho].to_i,
			iTotalRecords: Role.count,
			iTotalDisplayRecords: roles.total_entries,
			aaData: data
		}
	end

	private

	def data
		roles.map do |role|
			[
				@view.check_box(:is_active,"id_#{role.id}".to_sym,checked: !role.is_active,data: {"role-id"=> role.id}),
				link_to(role.name, role),
				ERB::Util.h(role.created_at.strftime("%B %e, %Y")),
				ERB::Util.h(role.updated_at.strftime("%B %e, %Y"))
			]
		end
	end

	def roles
		@roles ||= fetch_roles
	end

	def fetch_roles
		roles = Role.order("#{sort_column} #{sort_direction}")
		roles = roles.page(page).per_page(per_page)
		if params[:sSearch].present?
			roles = roles.where("name like :search", search: "%#{params[:sSearch]}%")
		end
		roles
	end

	def page
		params[:iDisplayStart].to_i/per_page + 1
	end

	def per_page
		params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
	end

	def sort_column
		columns = %w[is_active name created_at updated_at]
		columns[params[:iSortCol_0].to_i]
	end

	def sort_direction
		params[:sSortDir_0] == "desc" ? "desc" : "asc"
	end
end
