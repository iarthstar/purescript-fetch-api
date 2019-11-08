"use strict";

const fetch = require("node-fetch");

const arr2json = (arr) => {
    let json = {};
    arr.forEach(elem => json[elem[0]] = elem[1]);
    return json;
}

const doSomethingAsync = (url, options, req, cb) => {

    let config = arr2json(options);

    let headers = options.filter(elem => elem[0] == "headers");
    if (headers.length == 1) {
        config.headers = arr2json(headers[0][1]);
    }

    config.body = JSON.stringify(req);

    if (config.method == "GET" || config.method == "DELETE") {
        config.params = config.data;
        delete config.data;
    }
    let resp = {};

    fetch(url, config)
        .then(res => {
            Object.assign(resp, {
                ok: res.ok,
                status: res.status,
                statusText: res.statusText,
            });
            return res.json();
        })
        .then(data => {
            Object.assign(resp, { body: data });
            cb(false, resp);
        })
        .catch(err => cb(true, err));
}

exports._fetch = url => options => req => (onError, onSuccess) => {
    let cancel = doSomethingAsync(url, options, req, function (err, res) {
        if (err) {
            onError(res);
        } else {
            onSuccess(res);
        }
    });
    return (cancelError, onCancelerError, onCancelerSuccess) => {
        cancel();
        onCancelerSuccess();
    }
}
