import { AUTH_LOGIN, AUTH_LOGOUT, AUTH_CHECK, AUTH_ERROR } from 'react-admin';
import axios from 'axios';

export default (type, params) => {
    /*
    if (type === AUTH_LOGIN) {
        const { username, password } = params;
        if (!(username === 'admin' && password === 'admin')){
            return Promise.reject('Hatalı kullanıı yada şifre');
        } 

        localStorage.setItem('username', username);
        // accept all username/password combinations
        return Promise.resolve();
    }
    */
    if (type === AUTH_LOGIN) {
        const { username, password } = params;
        const request = new Request('https://mydomain.com/authenticate', {
            method: 'POST',
            body: JSON.stringify({ username, password }),
            headers: new Headers({ 'Content-Type': 'application/json' }),
        })
        return fetch(request)
            .then(response => {
                if (response.status < 200 || response.status >= 300) {
                    throw new Error(response.statusText);
                }
                return response.json();
            })
            .then(({ token }) => {
                localStorage.setItem('token', token);
                localStorage.setItem('username', username);
                // accept all username/password combinations
                return Promise.resolve();
            });
    }

    /*
    if (type === AUTH_LOGIN) {
        debugger
        const { username, password } = params;

        debugger
        axios.get('http://an80x86.proxy.beeceptor.com/user')
        .then(function (response) {
            console.log(response);
            return Promise.resolve();
        })
        .catch(function (error) {
            return Promise.reject('Login error');
        });
    }
    */
    if (type === AUTH_LOGOUT) {
        localStorage.removeItem('username');
        return Promise.resolve();
    }
    if (type === AUTH_ERROR) {
        return Promise.resolve();
    }
    if (type === AUTH_CHECK) {
        return localStorage.getItem('username')
            ? Promise.resolve()
            : Promise.reject();
    }
    return Promise.reject('Unkown method');
};
