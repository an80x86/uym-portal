import React from 'react';
import PropTypes from 'prop-types';
import shouldUpdate from 'recompose/shouldUpdate';
import ContentCreate from '@material-ui/icons/Create';
import { linkToRecord } from 'ra-core';

import Link from '../Link';
import Button from './Button';

const EditButton = ({
    basePath = '',
    label = 'ra.action.edit',
    record = {},
    ...rest
}) => (
    <Button
        component={Link}
        to={linkToRecord(basePath, record.id)}
        label={label}
        {...rest}
    >
        <ContentCreate />
    </Button>
);

EditButton.propTypes = {
    basePath: PropTypes.string,
    className: PropTypes.string,
    classes: PropTypes.object,
    label: PropTypes.string,
    record: PropTypes.object,
};

const enhance = shouldUpdate(
    (props, nextProps) =>
        props.translate !== nextProps.translate ||
        (props.record &&
            nextProps.record &&
            props.record.id !== nextProps.record.id) ||
        props.basePath !== nextProps.basePath ||
        (props.record == null && nextProps.record != null)
);

export default enhance(EditButton);
