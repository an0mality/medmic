module ApplicationHelper
  def bootstrap_class_for flash_type
    { success: "alert-success", error: "alert-danger", alert: "alert-warning", notice: "alert-info" }[flash_type] || flash_type.to_s
  end

  def flash_messages(opts = {})
    flash.each do |msg_type, message|
      concat(content_tag(:div, message, class: "alert alert-#{bootstrap_class_for(msg_type)}") do
               concat content_tag(:button, 'x', class: "close", data: { dismiss: 'alert' })
               concat message
             end)
    end
    nil
  end

  def find_role current_user
    case true
      when current_user.vpch && !current_user.mz
        role = 1
      when current_user.spid
        role = 2
      when current_user.onko
        role = 3
      when current_user.mz && current_user.vpch || current_user.admin
        role = 4
    end
    role
  end

  def manual current_user
    link = []
    open = Document.open
    ticket = Document.ticket
    if current_user.present?
      if open.present?
        link << (link_to 'инструкция вход в систему', document_path(open.id), target: :blank)
      end
      if ticket.present?
        link << (link_to 'инструкция по созданию заявок в тех.поддержку', document_path(ticket.id), target: :blank)
      end
      if current_user.vpch || current_user.onko || current_user.spid
        vpch = Document.vpch
        if vpch.present?
          link << (link_to 'инструкция для модуля ВПЧ', document_path(vpch.id), target: :blank)
        end
      end
      if current_user.mse && !current_user.mz
        mse = Document.ipra_user
        if mse.present?
          link << (link_to 'инструкция для модуля ИПРА', document_path(mse.id), target: :blank)
        end
      end
      if current_user.mse && current_user.mz
        mse_mz = Document.ipra_mz
        if mse_mz.present?
          link << (link_to 'инструкция для модуля ИПРА_МЗ', document_path(mse_mz.id), target: :blank)
        end
      end
      if current_user.feed && !current_user.mz
        feed = Document.feed_user
        if feed.present?
          link << (link_to 'инструкция для модуля Детское питание', document_path(feed.id), target: :blank)
        end
      end
      if current_user.feed && current_user.mz
        feed_mz = Document.feed_mz
        if feed_mz.present?
          link << (link_to 'инструкция для модуля Детское питание_МЗ', document_path(feed_mz.id), target: :blank)
        end
      end
      if current_user.moderator
        moderator = Document.moder
        if moderator.present?
          link << (link_to 'инструкция для модуля Модератор', document_path(moderator.id), target: :blank)
        end
      end
      if current_user.frmr
        frmr = Document.frmr
        if frmr.present?
          link << (link_to 'инструкция для модуля Регистр врачей и фельдшеров, имеющих право выписки льготных рецептов', document_path(frmr.id), target: :blank)
        end
      end
    end
    link.join(", ").html_safe
  end

end
