import React from 'react';
import { render } from 'react-dom'
import { BrowserRouter } from 'react-router-dom'
import App from './App';

import './index.css';

render( 
    <BrowserRouter>
        <App />
    </BrowserRouter>,
    document.querySelector('#root')
)
