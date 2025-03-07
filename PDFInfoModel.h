#ifndef PDFINFOMODEL_H
#define PDFINFOMODEL_H

#include <QAbstractListModel>
#include <QObject>
#include <vector>
#include "PDFInfo.h"
#include "Utils.h"
#include "PDFSetProvider.h"

class PDFInfoModel : public QAbstractListModel
{
    Q_OBJECT

public:
    enum PDFRoles {
        PdfSetNameRole = Qt::UserRole + 1,
        QMaxRole,
        QMinRole,
        XMinRole,
        XMaxRole,
        KtMinRole,
        KtMaxRole,
        NumMembersRole,
        FlavorsRole,
        FormatRole,
        OrderQCDRole,
        PDFSetType
    };
    Q_ENUM(PDFRoles)

    explicit PDFInfoModel(QObject *parent = nullptr);

signals:

public:
    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;
    Q_INVOKABLE void fillPDFInfoModel();
    Q_INVOKABLE void filterByPDFType(const QString &pdfType); // New method to filter by type
    Q_INVOKABLE void cLearModel();
    Q_INVOKABLE QVariantMap get(int index) const;
    Q_INVOKABLE int pdfCount() const;
    Q_INVOKABLE bool pdfSetAlreadyExists(const QString& pdfSetName);

private:
    QVector<PDFInfo> m_pdfList;           // All PDF sets
    QVector<PDFInfo> m_filteredPdfList;   // Filtered PDF sets based on type
    PDFSetProvider m_pdfSetProvider;
};

#endif // PDFINFOMODEL_H
