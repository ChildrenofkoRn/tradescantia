import Rails from '@rails/ujs'

document.addEventListener('turbolinks:load', function() {

  let users = document.querySelector('.users > .table')

  if (users) {
    document.querySelector('.make-admin')
      .addEventListener('click', handlerChangeUserType('Admin'))

    document.querySelector('.make-user')
      .addEventListener('click', handlerChangeUserType('User'))

    document.querySelector('.uncheck-all')
      .addEventListener('click', () => { uncheckBoxes(checkedBoxes()) })

    document.querySelectorAll("input[type=checkbox]").forEach(function(checkbox) {
      checkbox.addEventListener('change', function() {
        if (this.checked) {
          if (checkedBoxes().length > 1) return
          toggleButtons(true)
        } else {
          if (checkedBoxes().length) return
          toggleButtons(false)
        }
      })
    })

  }
})

function checkedBoxes() {
  return document.querySelectorAll('table input:checked')
}

function toggleButtons(show) {
  const buttons = document.querySelector('.users .actions');
  (show) ? buttons.classList.remove('disabled-panel') : buttons.classList.add('disabled-panel')
}

function handlerChangeUserType(userType){
  return async function () {
    const checkBoxes = checkedBoxes()
    const usernames = checkedUsernames(checkBoxes)
    const confirmResult = confirm(`You want to make an ${userType}: ${usernames} ?`)

    if (!confirmResult) return
    const params = {ids: checkedIds(checkBoxes), type: userType}
    let response = await xhrUsersPatch(params)

    if (response.ok) {
      uncheckBoxes(checkBoxes)
      changeTypeInRow(checkBoxes, userType)
      changeTypeClass(checkBoxes, userType)
    } else {
      await showError(response.status)
    }
  }
}

function checkedUsernames(checkBoxes) {
  const names = [].map.call(checkBoxes, function(checkBox) {
    return checkBox.closest('tr').querySelector('.username').textContent
  });
  return names.join(', ')
}

function checkedIds(checkBoxes) {
  return [].map.call(checkBoxes, function(checkBox) {
    return checkBox.closest('tr').dataset.userId
  })
}

function uncheckBoxes(checkedBoxes){
  const event = new Event('change')
  checkedBoxes.forEach( function(checkedBox) {
      checkedBox.checked = false
      checkedBox.dispatchEvent(event)
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

function changeTypeClass(checkBoxes, userType){
  const types = ['User', 'Admin']
  if (userType === types[0]) types.reverse()

  checkBoxes.forEach( function(checkBox) {
    const user = checkBox.closest('tr')
    user.classList.remove(`type-${types[0]}`)
    user.classList.add(`type-${types[1]}`)
    }
  )
}

function errorMessage(status) {
  const errors = {
    400: "Bad Request.",
    401: "You are not authorized to perform this action.",
    422: 'Unprocessable Entity.',
    'DEF': 'If this error repeats, contact administrator.'
  }
  return `${status} Error: ${errors[status] || errors['DEF']}`
}

async function showError(status) {
  const div = document.querySelector('.resource-errors.alert')
  div.classList.add('hide')
  div.innerHTML = errorMessage(status)
  div.classList.remove('hide')

  await new Promise(resolve => setTimeout(resolve, 5000));
  div.innerHTML = ''
  div.classList.add('hide')
}

// Yep, of course we would use Rails UJS
function xhrUsersPatch(params) {
  const json = JSON.stringify({ user: params } )

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
