'use strict'

import React from 'react'
import ReactDOM from 'react-dom'

import App from './components/app.jsx'

if (document.readyState === 'loading') {
  window.addEventListener('load', onLoad)
} else {
  onLoad()
}

async function onLoad () {
  const isGitHub = (window.location.hostname.endsWith('.github.io'))
  if (isGitHub) registerServiceWorker()

  ReactDOM.render(
    <App />,
    document.getElementById('app-wrapper')
  )
}

async function registerServiceWorker () {
  if (navigator.serviceWorker == null) return

  navigator.serviceWorker.register('/us-weather/service-worker.js', { scope: '/us-weather/' })
}
