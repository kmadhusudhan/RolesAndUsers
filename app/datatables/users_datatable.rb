class UsersDatatable
	delegate :params, :h, :link_to, :number_to_currency, to: :@view

	def initialize(view)
		@view = view
	end

	def as_json(options = {})
		{
			sEcho: params[:sEcho].to_i,
			iTotalRecords: User.count,
			iTotalDisplayRecords: users.total_entries,
			aaData: data
		}
	end

	private

	def data
		users.map do |user|
			[
				link_to(user.first_name, user),
				user.last_name,
				user.email,
				user.created_at.strftime("%B %e, %Y"),
				user.updated_at.strftime("%B %e, %Y"),
				user.roles.map(&:name).join(","),
				@view.image_tag(user.photo)
			]
		end
	end

	def users
		@users ||= fetch_users
	end

	def fetch_users
		users = User.order("#{sort_column} #{sort_direction}")
		users = users.page(page).per_page(per_page)
		if params[:sSearch].present?
			users = users.where("first_name like :search or last_name like :search or email like :search", search: "%#{params[:sSearch]}%")
		end
		users
	end

	def page
		params[:iDisplayStart].to_i/per_page + 1
	end

	def per_page
		params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
	end

	def sort_column
		columns = %w[first_name last_name email created_at updated_at]
		columns[params[:iSortCol_0].to_i]
	end

	def sort_direction
		params[:sSortDir_0] == "desc" ? "desc" : "asc"
	end
end
