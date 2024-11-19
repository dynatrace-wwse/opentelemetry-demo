// Copyright The OpenTelemetry Authors
// SPDX-License-Identifier: Apache-2.0

import { useEffect, useState } from 'react';
import * as S from './Footer.styled';
import SessionGateway from '../../gateways/Session.gateway';
import { CypressFields } from '../../utils/Cypress';
import PlatformFlag from '../PlatformFlag';
import { getCookie } from "cookies-next";

const currentYear = new Date().getFullYear();

const Footer = () => {
  const [sessionId, setSessionId] = useState('');
  const [userId, setUserId] = useState('');

  useEffect(() => {
    setSessionId(getCookie('SESSIONID') as string);
    setUserId(SessionGateway.getSession().userId);
  }, []);

  return (
    <S.Footer>
      <div>
        <p>This website is hosted for demo purpose only. It is not an actual shop.</p>
        <p>
          <span data-cy={CypressFields.SessionId}>session-id: {sessionId}</span><br /><span data-cy={CypressFields.UserId}>user-id: {userId}</span>
        </p>
      </div>
      <p>
        @ {currentYear} OpenTelemetry (<a href="https://github.com/open-telemetry/opentelemetry-demo">Source Code</a>)
      </p>
      <PlatformFlag />
    </S.Footer>
  );
};

export default Footer;
