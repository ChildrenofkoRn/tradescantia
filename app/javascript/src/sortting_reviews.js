document.addEventListener('turbolinks:load', function() {
  let control_title = document.querySelector('.sort-by-title')
  let control_rank = document.querySelector('.sort-by-rank')

  if (control_title) control_title.addEventListener('click', sortRowsByTitle)
  if (control_rank) control_rank.addEventListener('click', sortRowsByRank)
})

const arrows = { up: '.bi.bi-arrow-up', down: '.bi.bi-arrow-down', updown: '.bi.bi-arrow-down-up' }

function sortRowsByTitle() {
  hiddenArrowsOnColumn('.sort-by-rank')
  hiddenArrowUpDown(this)
  sortRowsBy(this)
}

function sortRowsByRank() {
  hiddenArrowsOnColumn('.sort-by-title')
  hiddenArrowUpDown(this)
  sortRowsBy(this, 3, 'rank_float')
}

function sortRowsBy(columnHead, columnNum = 1, type_sort = 'text') {
  let tbody = document.querySelector('tbody')
  let rows = document.querySelectorAll('tr.review-short')

  let sortedRows = Array.from(rows)

  if (columnHead.querySelector(arrows.up).classList.contains('hide')) {
    // sortedRows.sort(compareRows(columnNum, type_sort))
    sortedRows = quickSort(sortedRows, compareRows(columnNum, type_sort, true, true))
    switcher_arrows(columnHead, arrows.up, arrows.down)
  } else {
    // sortedRows.sort(compareRows(columnNum, type_sort, false))
    sortedRows = quickSort(sortedRows, compareRows(columnNum, type_sort, false, true))
    switcher_arrows(columnHead, arrows.down, arrows.up)
  }

  let sortedTbody	= document.createElement('tbody')

  for (let i = 0, n=sortedRows.length; i < n; i++) {
    sortedTbody.appendChild(sortedRows[i])
  }

  tbody.parentNode.replaceChild(sortedTbody, tbody)
}

// base implementation quick sort
// https://jsben.ch/lap2T bench of sorts
// Firefox 112.0.2 quickSort is faster
// Brave v1.49.1 quickSort is slower
// However, this may depend on the incoming data
function quickSort(array, compareHandler = (a, b) => a > b) {
  if (array.length < 2) return array

  let pivot = array[0]
  const left = []
  const right = []

  for (let i = 1; i < array.length; i++) {
    if (compareHandler(pivot, array[i])) {
      left.push(array[i]);
    } else {
      right.push(array[i]);
    }
  }

  return [...quickSort(left, compareHandler), pivot, ...quickSort(right, compareHandler)]
}

function compareRows(tdNum, type, asc = true, booleanMode = false) {
  return function(rowl, row2) {
    let tdChild = `td:nth-child(${tdNum})`
    let textRowOne = rowl.querySelector(tdChild).firstElementChild.textContent
    let textRowTwo = row2.querySelector(tdChild).firstElementChild.textContent
    let [valueOne, valueTwo] = set_type(textRowOne, textRowTwo, type)

    if (booleanMode) {
      // quickSort need boolean
      return asc ? valueOne > valueTwo : valueOne < valueTwo
    } else {
      // ref sort need -1 0 1 like <=>
      let order = (asc) ? 1 : -1
      if (valueOne > valueTwo) return 1 * order
      if (valueOne < valueTwo) return -1 * order
      return 0
    }

  }
}

function set_type(textValOne, textValTwo, type = 'text') {
  if (type === 'text' ) { return [textValOne.toLowerCase(), textValTwo.toLowerCase()] }
  // need if float as string
  return [Number(textValOne), Number(textValTwo)]
}

function hiddenArrowsOnColumn(columnClass) {
  let column = document.querySelector(columnClass)
  if (!column) return

  column.querySelector(arrows.up).classList.add('hide')
  column.querySelector(arrows.down).classList.add('hide')
  column.querySelector(arrows.updown).classList.remove('hide')
}

function hiddenArrowUpDown(element) {
  element.querySelector(arrows.updown).classList.add('hide')
}

function switcher_arrows(element, arrow_show, arrow_hide) {
  element.querySelector(arrow_show).classList.remove('hide')
  element.querySelector(arrow_hide).classList.add('hide')
}
