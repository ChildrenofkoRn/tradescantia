import Rails from '@rails/ujs'

document.addEventListener('turbolinks:load', function() {
  console.log('DAO')
  let users = document.querySelector('.users > .table')

  if (users) {

    document.querySelector('.make-admin')
      .addEventListener('click', handlerChangeUserType('Admin'))

    document.querySelector('.make-user')
      .addEventListener('click', handlerChangeUserType('User'))

    document.querySelectorAll("input[type=checkbox]").forEach(function(checkbox) {
      checkbox.addEventListener('change', function() {
        if (this.checked) {
          if (checkedBoxes().length > 1) return
          toggle_buttons(true)
        } else {
          if (checkedBoxes().length) return
          toggle_buttons(false)
        }
      })
    })

  }
})

function handlerChangeUserType(userType){
  return async function () {
    const checkBoxes = checkedBoxes()
    const usernames = checkedUsernames(checkBoxes)
    let confirmResult = confirm(`You want to make an ${userType}: ${usernames} ?`)

    if (!confirmResult) return
    const params = {ids: checkedIds(checkBoxes), type: userType}
    let response = await xhrUsersPatch(params)

    if (response.ok) {
      console.log('Waiting?')
      uncheckBoxes(checkBoxes)
      changeTypeInRow(checkBoxes, userType)
      changeTypeClass(checkBoxes, userType)
    }
  }
}

function changeTypeClass(checkBoxes, userType){
  let types = ['User', 'Admin']
  if (userType === types[0]) types.reverse()

  checkBoxes.forEach( function(checkBox) {
    const user = checkBox.closest('tr')
    user.classList.remove(`type-${types[0]}`)
    user.classList.add(`type-${types[1]}`)
    }
  )
}

function changeTypeInRow(checkBoxes, userType){

  checkBoxes.forEach( function(checkBox) {
      const tdType = checkBox.closest('tr').querySelector('.type')
      tdType.innerHTML = userType
    }
  )
}

function uncheckBoxes(checkedBoxes){
  const event = new Event('change')
  checkedBoxes.forEach( function(checkedBox) {
    checkedBox.checked = false
    checkedBox.dispatchEvent(event)
    }
  )
}

function checkedBoxes() {
  return document.querySelectorAll('table input:checked')
}

function toggle_buttons(show) {
  const buttons = document.querySelector('.users .actions');
  (show) ? buttons.classList.remove('disabled-panel') : buttons.classList.add('disabled-panel')
}

function xhrUsersPatch(params) {
  let json = JSON.stringify({ user: params } )

  return fetch('/dashboard/users/change_type', {
    method: 'PATCH',
    headers: {
      Accept: 'application/json',
      'X-Request-With': 'XMLHttpRequest',
      'X-CSRF-Token': Rails.csrfToken(),
      'Content-Type': 'application/json',
    },
    body: json,
    credentials: 'same-origin'
  })
}

function checkedUsernames(checkBoxes) {
  let names = [].map.call(checkBoxes, function(checkBox) {
    return checkBox.closest('tr').querySelector('.username').textContent
  });
  console.log(names.join(', '))
  return names.join(', ')
}

function checkedIds(checkBoxes) {
  return [].map.call(checkBoxes, function(checkBox) {
    return checkBox.closest('tr').dataset.userId;
  })
}