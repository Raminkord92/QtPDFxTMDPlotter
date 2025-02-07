#ifndef DRAGDROPMODEL_H
#define DRAGDROPMODEL_H

#include <QAbstractListModel>
#include <QStringList>

class DragDropModel : public QAbstractListModel
{
    Q_OBJECT

public:
    enum Roles {
        NameRole = Qt::UserRole + 1,
        XRole,
        YRole,
        ColorRole
    };

    explicit DragDropModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void addItem(const QString &name, qreal x, qreal y, const QString &color);
    Q_INVOKABLE void removeItem(int index);

private:
    struct Item {
        QString name;
        qreal x;
        qreal y;
        QString color;
    };
    QList<Item> m_items;
};

#endif // DRAGDROPMODEL_H
