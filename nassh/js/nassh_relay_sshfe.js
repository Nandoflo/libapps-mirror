// Copyright 2018 The Chromium OS Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

'use strict';

/**
 * @fileoverview Implementation for the ssh-fe@google.com proxy.
 */

/**
 * SSH-FE relay implementation.
 *
 * @param {!hterm.Terminal.IO} io
 * @param {!Object} options
 * @param {string} username
 * @constructor
 */
nassh.Relay.Sshfe = function(io, options, username) {
  this.io = io;
  this.proxyHost = options['--proxy-host'];
  this.proxyPort = options['--proxy-port'] || 443;
  this.username = username;
  this.sshAgent_ = options['--ssh-agent'] ||
      nassh.GoogleRelay.defaultGnubbyExtension;
  this.relayServer = `wss://${this.proxyHost}:${this.proxyPort}`;
};

/**
 * Initialize this relay object.
 */
nassh.Relay.Sshfe.prototype.init = function() {};

/**
 * Return an nassh.Stream object that will handle the socket stream
 * for this relay.
 *
 * @param {number} fd
 * @param {string} host
 * @param {number} port
 * @param {!nassh.StreamSet} streams
 * @param {function()} onOpen
 * @return {!nassh.Stream}
 */
nassh.Relay.Sshfe.prototype.openSocket = function(fd, host, port, streams,
                                                  onOpen) {
  const settings = {
    io: this.io,
    relayHost: this.proxyHost,
    relayPort: this.proxyPort,
    relayUser: this.username,
    host: host,
    port: port,
    sshAgent: this.sshAgent_,
  };
  return streams.openStream(nassh.Stream.RelaySshfeWS, fd, settings, onOpen);
};
